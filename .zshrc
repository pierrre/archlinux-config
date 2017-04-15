ulimit -n 4096

export ZSH=/home/pierre/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git git-extras colored-man history-substring-search golang)
source $ZSH/oh-my-zsh.sh

export EDITOR=nano
export PATH=$PATH:$HOME/Logiciels
export CDPATH=.:$HOME

alias drop-caches="sudo zsh -c 'sync;echo 3 > /proc/sys/vm/drop_caches'"
alias clean-swap="sudo zsh -c 'swapoff -a && swapon -a'"

GITHUB_TOKEN=xxx
git-clone-organization() {
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
	echo $urls | parallel -v -j 8 git clone {}
}
git-pull-dir() {
	set -ex
	dir=$1
	if [ -z "$dir" ]; then
		dir="."
	fi
	find $dir -type d -name ".git" | xargs dirname | parallel -v -j 8 git -C {} pull
}

export GIMME_GO_VERSION=1.8.1
export GIMME=$HOME/.gimme
export GIMME_TYPE=source
export GIMME_SILENT_ENV=1
export GIMME_DEBUG=1
export PATH=$PATH:$GIMME/bin
export GIMME_ENV=$GIMME/envs/go$GIMME_GO_VERSION.env
if [ -f "$GIMME_ENV" ]; then
	source $GIMME_ENV
fi
gimme-update() {
	set -ex
	mkdir -p $GIMME/bin
	curl -o $GIMME/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
	chmod u+x $GIMME/bin/gimme
}
export GOPATH=$HOME/Go
export PATH=$PATH:$GOPATH/bin
export CDPATH=$CDPATH:$GOPATH/src:$GOPATH/src/github.com/pierrre
gopath-update() {
	set -ex
	git-pull-dir $GOPATH
	go get -v -d .../
	gopath-refresh
}
gopath-refresh() {
	set -ex
	rm -rf $GOPATH/bin $GOPATH/pkg
	go get -v golang.org/x/tools/cmd/benchcmp
	go get -v golang.org/x/tools/cmd/godoc
	go get -v github.com/golang/dep/cmd/dep
	go get -v github.com/tools/godep
	go get -v github.com/rakyll/hey
}

export PATH=$PATH:$HOME/Logiciels/android-sdk/platform-tools
alias adb-screencap="adb exec-out screencap -p"
alias fix-adb="sudo zsh -c 'killall adb;/home/pierre/Logiciels/android-sdk/platform-tools/adb start-server'"
alias apktool="java -jar $HOME/Logiciels/apktool.jar"

alias start-docker="sudo systemctl start docker"
alias start-mongo="docker pull mongo; docker container run --rm --detach --net=host --name=mongo mongo"
alias start-rabbitmq="docker pull rabbitmq:management-alpine; docker container run --rm --detach --net=host --name=rabbitmq rabbitmq:management-alpine"
alias start-redis="docker pull redis:alpine; docker container run --rm --detach --net=host --name=redis redis:alpine"