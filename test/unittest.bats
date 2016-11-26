#!/bin/bash

myconf=./config.conf
export CONFFILE=$myconf
source ../mygit_manager

log() {
  eval "echo \"$1=\$$1\" >> log"
}

@test "config loaded" {
  VAR=value
  loadconf $myconf
  [[ $VAR == var ]]
}

@test "CONFFILE match export var" {
  # outside config is present
  [[ "$CONFFILE" == "$myconf"  ]]

  export CONFFILE=me
  source ../mygit_manager
  [[ $CONFFILE == me ]]
  unset CONFFILE
  [[ "$CONFFILE" == "" ]]
  source ../mygit_manager
  [[ "$CONFFILE" != "" ]]
}

@test "check_repo_name" {
  run check_repo_name pipo
  [[ $status -eq 0 ]]
  run check_repo_name .molo
  [[ $status -eq 1 ]]
}

@test "loadconf" {
  loadconf $CONFFILE
  [[ "$REPO_BASE_DIR" == "./test_repos"  ]]
}

@test "action_init is creating REPO_BASE_DIR" {
  loadconf $CONFFILE
  [[ ! -z "$REPO_BASE_DIR" ]]
  [[ ! -d "$REPO_BASE_DIR" ]]
  run action_init
  [[ -d "$REPO_BASE_DIR" ]]
  rmdir "$REPO_BASE_DIR"
}

@test "action_add" {
  [[ "$PWD" =~ /test$ ]]
  loadconf $CONFFILE
  [[ "$REPO_BASE_DIR" == "./test_repos"  ]]
  [[ "$REPO_BASE_DIR" == "./test_repos"  ]]
}
