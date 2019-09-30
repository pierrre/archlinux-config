ulimit -n 4096

if [ -f '/home/pierre/Logiciels/google-cloud-sdk/path.zsh.inc' ]; then source '/home/pierre/Logiciels/google-cloud-sdk/path.zsh.inc'; fi

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
	kubectl
)
source $ZSH/oh-my-zsh.sh
zstyle ":completion:*:commands" rehash 1

export EDITOR=nano
export PATH=$PATH:$HOME/Logiciels
export CDPATH=.:$HOME

alias drop-caches="sudo zsh -c 'sync;echo 3 > /proc/sys/vm/drop_caches'"
alias clean-swap="sudo zsh -c 'swapoff -a && swapon -a'"

if [ -f '/home/pierre/Logiciels/google-cloud-sdk/completion.zsh.inc' ]; then source '/home/pierre/Logiciels/google-cloud-sdk/completion.zsh.inc'; fi

start-docker() {(
	set -ex
	sudo systemctl start docker
)}
start-mongo() {(
	set -ex
	start-docker
	docker image pull mongo:latest
	docker container run --rm --detach --net=host --name=mongo mongo:latest --replSet=local
	sleep 5
	docker container exec -it mongo mongo --eval 'rs.initiate()'
)}
start-rabbitmq() {(
	set -ex
	start-docker
	docker image pull rabbitmq:management-alpine
	docker container run --rm --detach --net=host --name=rabbitmq rabbitmq:management-alpine
	sleep 10
	docker container exec -it rabbitmq rabbitmq-plugins enable rabbitmq_shovel_management rabbitmq_top
)}
start-redis() {(
	set -ex
	start-docker
	docker pull redis:alpine
	docker container run --rm --detach --net=host --name=redis redis:alpine
)}
export ELASTICSEARCH_VERSION=7.3.2
start-elasticsearch() {(
	set -ex
	start-docker
	docker container run --rm --detach --net=host -e discovery.type=single-node --name=elasticsearch docker.elastic.co/elasticsearch/elasticsearch:${ELASTICSEARCH_VERSION}
	docker image pull elastichq/elasticsearch-hq:latest
	docker container run --rm --detach --net=host --name elasticsearch-hq elastichq/elasticsearch-hq:latest
	sleep 5
	xdg-open http://localhost:5000
)}
start-kafka() {(
	set -ex
	start-docker
	docker image pull bitnami/zookeeper:latest
	docker container run --rm --detach --net=host -e ALLOW_ANONYMOUS_LOGIN=yes --name=zookeeper bitnami/zookeeper:latest
	docker image pull bitnami/kafka:latest
	docker container run --rm --detach --net=host -e ALLOW_PLAINTEXT_LISTENER=yes -e KAFKA_DELETE_TOPIC_ENABLE=true --name=kafka bitnami/kafka:latest
	docker image pull hlebalbau/kafka-manager:stable
	docker container run --rm --detach --net=host -e ZK_HOSTS=localhost:2181 --name=kafka-manager hlebalbau/kafka-manager:stable
	sleep 5
	xdg-open http://localhost:9000
)}

GITHUB_TOKEN=xxx
git-clone-organization() {(
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
	find $dir -type d -name ".git" | xargs dirname | parallel -v -j 8 git -C {} pull --all --tags --prune
)}

export GIMME_GO_VERSION=1.13
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
export CDPATH=$CDPATH:$HOME/gosrc:$HOME/gosrc/github.com/pierrre
gotools-update() {(
	set -ex
	GO111MODULE=on\
	go get -v -u\
	golang.org/x/tools/cmd/benchcmp\
	golang.org/x/tools/cmd/godoc\
	github.com/google/pprof\
	github.com/rakyll/hey
)}
