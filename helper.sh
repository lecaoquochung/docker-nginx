#!/bin/bash

readonly NAME="docker-jenkins"
readonly REPO="https://github.com/ddnb/$NAME"

helps() {
	case $1 in
		all|*) allhelps ;;
	esac
}

allhelps() {
cat <<EOF
Usage: ./help.sh COMMAND
[help|usage|build|init|up|down|restart|status|logs|ssh]
[Commands]
  build        Build docker service
  up or start  Run docker-compose as daemon (or up)
  down or stop Terminate all docker containers run by docker-compose (or down)
  restart      Restart docker-compose containers
  status       View docker containers status
  logs         View docker containers logs
  ssh          ssh cli
  open         open localhost test page
EOF
}

# Usage
usage() {
	echo "Usage:"
	echo "${0} [help|usage|build|init|up|down|restart|status|logs|ssh]"
}

# Docker compose build
build() {
	docker-compose build
}

# Docker compose up
start() {
	docker-compose up -d
}

# Docker compose down
stop() {
	docker-compose down
}

# Docker compose restart
restart() {
	docker-compose restart
}

# Docker compose status
status() {
	docker-compose ps
}

# Docker compose logs
logs() {
	case $2 in
		liho|*)  docker-compose logs ;;
	esac
}

# ssh cli
run_ssh() {
	case $1 in
		*) docker-compose exec $1 /bin/bash ;;
	esac
}

# open test page
# TODO: update hosts file with test domain nginx.test
# echo "127.0.0.1  nginx.test" >> /etc/hosts
run_open() {
	case $2 in
		php) open http://nginx.test:8080/index.php ;;
		*)  open http://nginx.test:8080/index.html ;;
	esac
}

case $1 in
	open) run_open ${1} ${2};;
	init) init ${2:-v2};;
	build) build ;;
	start|up) start ;;
	stop|down) stop ;;
	restart|reboot) restart ;;
	status|ps) status ;;
	logs) logs ${2:-all} ;;
	ssh) run_ssh ${2:-php} ;;
	*) helps ;;
esac