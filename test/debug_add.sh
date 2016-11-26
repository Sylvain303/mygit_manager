
export CONFFILE=./config.conf
. ../mygit_manager

die() {
  echo $1
  return 1
}

exit() {
  echo $1
  return $2
}

loadconf $CONFFILE
action_env
action_init
set -x
action_add pipo
