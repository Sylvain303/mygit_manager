#!/bin/bash

mygit_manager=../mygit_manager
conf=./mygit_manager.conf
myrepos=./repos_git

source common.sh

_create_config $conf $myrepos
export CONFFILE=$conf

@test "functional: init REPO_BASE_DIR" {
	run $mygit_manager init
  [[ $status -eq 0 ]]
  source $conf
	[[ -d "$REPO_BASE_DIR" ]]
  regexp="^$myrepos"
	[[ "$REPO_BASE_DIR" =~ $regexp ]]
}

@test "functional: add some_repos" {
	run $mygit_manager add some_repos
  [[ $status -eq 0 ]]
  source $conf
	[[ -d "$REPO_BASE_DIR/some_repos" ]]
}
