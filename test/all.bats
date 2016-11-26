#!/bin/bash

mygit_manager=../mygit_manager
conf=./mygit_manager.conf

_create_config() {
  cat << EOF > $conf
REPO_BASE_DIR=./repos_git
EOF
}


@test "init REPO_BASE_DIR" {
	_create_config
  export CONFFILE=$conf
	run $mygit_manager init
  [[ $status -eq 0 ]]
  source $conf
	[[ -d "$REPO_BASE_DIR" ]]

}
