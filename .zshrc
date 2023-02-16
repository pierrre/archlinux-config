ulimit -n 4096

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(
	colored-man-pages
	docker
	docker-compose
	git
	git-extras
	golang
	history-substring-search
)
source $ZSH/oh-my-zsh.sh
zstyle ":completion:*:commands" rehash 1

export EDITOR=nano
export BROWSER=google-chrome-stable
export PATH=$PATH:$HOME/Logiciels
export CDPATH=.:$HOME

alias drop-caches="sudo zsh -c 'sync;echo 3 > /proc/sys/vm/drop_caches'"
alias clean-swap="sudo zsh -c 'swapoff -a && swapon -a'"

start-docker() {(
	set -ex
	sudo systemctl start docker
)}
start-mongo() {(
	set -ex
	start-docker
	docker container run --pull=always --rm --detach --net=host --name=mongo mongo:latest --replSet=local --wiredTigerCacheSizeGB=0.5
	sleep 5
	docker container exec -it mongo mongo --eval 'rs.initiate()'
)}
start-rabbitmq() {(
	set -ex
	start-docker
	docker container run --pull=always --rm --detach --net=host --name=rabbitmq rabbitmq:management-alpine
	sleep 10
	docker container exec -it rabbitmq rabbitmq-plugins enable rabbitmq_shovel_management rabbitmq_top
)}
start-redis() {(
	set -ex
	start-docker
	docker container run --pull=always --rm --detach --net=host --name=redis redis:alpine
)}
export ELASTICSEARCH_VERSION=7.10.1
start-elasticsearch() {(
	set -ex
	start-docker
	docker container run --pull=always --rm --detach --net=host -e discovery.type=single-node --name=elasticsearch docker.elastic.co/elasticsearch/elasticsearch:${ELASTICSEARCH_VERSION}
	docker container exec -it elasticsearch elasticsearch-plugin install analysis-icu
	docker container restart elasticsearch
	docker container run --pull=always --rm --detach --net=host --name elasticsearch-hq elastichq/elasticsearch-hq:latest
	sleep 5
	xdg-open http://localhost:5000
)}
start-kafka() {(
	set -ex
	start-docker
	docker container run --pull=always --rm --detach --net=host -e ALLOW_ANONYMOUS_LOGIN=yes --name=zookeeper bitnami/zookeeper:latest
	docker container run --pull=always --rm --detach --net=host -e ALLOW_PLAINTEXT_LISTENER=yes -e KAFKA_DELETE_TOPIC_ENABLE=true --name=kafka bitnami/kafka:latest
	docker container run --pull=always --rm --detach --net=host -e ZK_HOSTS=localhost:2181 --name=kafka-manager hlebalbau/kafka-manager:stable
	sleep 5
	xdg-open http://localhost:9000
)}
start-clickhouse() {(
	set -ex
	start-docker
	docker container run --pull=always --rm --detach --net=host --name=clickhouse yandex/clickhouse-server:latest
)}
start-mysql() {(
	set -ex
	start-docker
	docker container run --pull=always --rm --detach --net=host -e MYSQL_ALLOW_EMPTY_PASSWORD=yes --name=mysql mysql:latest
)}
start-postgres() {(
	set -ex
	start-docker
	docker container run --pull=always --rm --detach --net=host -e POSTGRES_USER=user -e POSTGRES_PASSWORD=password -e POSTGRES_DB=database --name=postgres postgres:latest
)}

GITHUB_TOKEN=xxx
github-clone-organization() {(
	set -ex
	org=$1
	if [ -z "$org" ]; then
		echo "no organization argument"
		return 1
	fi
	urls=""
	page=1
	while true
	do
		json=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/orgs/$org/repos?page=$page&per_page=100")
		tmp=$(echo $json | jq -r '.[].ssh_url')
		if [ -z "$tmp" ]; then
			break
		fi
		if [ "$page" -ne 1 ]; then
			urls+=\\n
		fi
		urls+=$tmp
		page=$((page+1))
	done
	(
		set +e
		echo $urls | parallel -v -j 8 git clone {}
	)
)}
git-pull-dir() {(
	set -ex
	dir=$1
	if [ -z "$dir" ]; then
		dir="."
	fi
	find $dir -type d -name ".git" | xargs dirname | parallel -v -j 8 git -C {} pull --all --tags --force --prune
)}

export GIMME_GO_VERSION=1.20.1
export GIMME=$HOME/.gimme
export GIMME_TYPE=source
export GIMME_SILENT_ENV=1
export GIMME_DEBUG=1
export PATH=$PATH:$GIMME/bin
export GIMME_ENV=$GIMME/envs/go$GIMME_GO_VERSION.env
if [ -f "$GIMME_ENV" ]; then
	source $GIMME_ENV
fi
gimme-update() {(
	set -ex
	mkdir -p $GIMME/bin
	curl -o $GIMME/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
	chmod u+x $GIMME/bin/gimme
)}
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export CDPATH=$CDPATH:$HOME/Git/pierrre
gotools-update() {(
	set -ex
	go install -v golang.org/x/tools/cmd/godoc@latest
	go install -v golang.org/x/perf/cmd/benchstat@latest
)}
