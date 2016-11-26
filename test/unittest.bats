#!/bin/bash

myconf=./config.conf
export CONFFILE=$myconf
source ../mygit_manager

log() {
  if [[ $# -gt 1 ]]
  then
    eval "echo \"$1 $2=\$$2\" >> log"
  else
    eval "echo \"$1=\$$1\" >> log"
  fi
}

cleanup() {
  source $myconf
  [[ "$REPO_BASE_DIR" =~ ^\. ]] && \
    rm -rf "$REPO_BASE_DIR"
}

cleanup

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

@test "fail_if_repo exists and not_exists" {
  loadconf $CONFFILE
  mkdir -p $REPO_BASE_DIR
  [[ ! -d $REPO_BASE_DIR/pipo ]]

  run fail_if_repo exists pipo
  [[ $status -eq 0 ]]

  run fail_if_repo not_exists pipo
  [[ $status -eq 1 ]]

  mkdir $REPO_BASE_DIR/pipo
  [[ -d $REPO_BASE_DIR/pipo ]]

  run fail_if_repo exists pipo
  [[ $status -eq 1 ]]

  run fail_if_repo not_exists pipo
  [[ $status -eq 0 ]]

  cleanup
}

@test "action_add" {
  [[ "$PWD" =~ /test$ ]]
  loadconf $CONFFILE
  [[ "$REPO_BASE_DIR" == "./test_repos"  ]]
  action_init

  run action_add some_repos
  [[ -d "$REPO_BASE_DIR/some_repos" ]]
  [[ ! -z "$output" ]]
  [[ -d "$REPO_BASE_DIR/some_repos/branches" ]]

  cleanup
}
