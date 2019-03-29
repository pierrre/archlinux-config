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

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
	ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
	eval "$(<~/.ssh-agent-thing)" > /dev/null
	ssh-add > /dev/null 2>&1
fi

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
export ELASTICSEARCH_VERSION=6.6.2
start-elasticsearch() {(
	set -ex
	start-docker
	docker container run --rm --detach --net=host -e discovery.type=single-node --name=elasticsearch elasticsearch:${ELASTICSEARCH_VERSION}
	docker image pull elastichq/elasticsearch-hq:latest
	docker container run --rm --detach --net=host --name elastichsearch-hq elastichq/elasticsearch-hq:latest
)}
alias dive='docker image pull wagoodman/dive:latest && docker container run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/bin/docker wagoodman/dive:latest'

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

export GIMME_GO_VERSION=1.12.1
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
export CDPATH=$CDPATH:$GOPATH/src:$GOPATH/src/github.com/pierrre
gopath-update() {(
	set -ex
	git-pull-dir $GOPATH/src
	gopath-refresh
)}
gopath-refresh() {(
	set -ex
	rm -rf $GOPATH/bin $GOPATH/pkg/$(go env GOOS)_$(go env GOARCH)
	go get -v\
	golang.org/x/tools/cmd/benchcmp\
	golang.org/x/tools/cmd/godoc\
	github.com/google/pprof\
	github.com/golang/dep/cmd/dep\
	github.com/rakyll/hey
)}
