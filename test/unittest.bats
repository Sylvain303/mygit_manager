#!/bin/bash

# with conffile we can override defaults
myconf=./config.conf
export CONFFILE=$myconf
source ../mygit_manager
source common.sh

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
  [[ -z "$output" ]]

  run fail_if_repo not_exists pipo
  [[ $status -eq 1 ]]
  regexp='is missing'
  [[ "$output" =~ $regexp ]]

  git init --bare $REPO_BASE_DIR/pipo
  [[ -d $REPO_BASE_DIR/pipo/branches ]]

  run fail_if_repo exists pipo
  [[ $status -eq 1 ]]
  regexp='already a repository named'
  [[ "$output" =~ $regexp ]]

  run fail_if_repo not_exists pipo
  [[ $status -eq 0 ]]
  [[ -z "$output" ]]

  cleanup
}

@test "action_show reponame" {
  loadconf $CONFFILE
  action_init
  git init --bare $REPO_BASE_DIR/reponame
  [[ -d $REPO_BASE_DIR/reponame/branches ]]

  run action_show reponame
  [[ $status -eq 0 ]]
  [[ ! -z "$output" ]]
}

@test "action_add" {
  [[ "$PWD" =~ /test$ ]]
  old_pwd=$PWD
  loadconf $CONFFILE
  [[ "$REPO_BASE_DIR" == "./test_repos"  ]]
  action_init

  run action_add some_repos
  [[ $status -eq 0 ]]
  [[ $PWD == $old_pwd ]]
  [[ -d "$REPO_BASE_DIR/some_repos" ]]
  [[ ! -z "$output" ]]
  [[ -d "$REPO_BASE_DIR/some_repos/branches" ]]

  cleanup
}

@test "action_rm" {
  loadconf $CONFFILE
  action_init
  action_add some_repos
  [[ -d "$REPO_BASE_DIR/some_repos/branches" ]]

  # no confirm
  run action_rm -f some_repos
  [[ $status -eq 0 ]]
  [[ ! -d "$REPO_BASE_DIR/some_repos/branches" ]]
  [[ -d "$REPO_BASE_DIR" ]]
}

@test "check_dir_repos" {
  loadconf $CONFFILE
  mkdir -p $REPO_BASE_DIR
  [[ ! -d $REPO_BASE_DIR/pipo ]]

  run check_dir_repos exists pipo
  [[ $status -eq 1 ]]

  run check_dir_repos not_exists pipo
  [[ $status -eq 0 ]]

  git init --bare $REPO_BASE_DIR/pipo
  [[ -d $REPO_BASE_DIR/pipo/branches ]]

  run check_dir_repos exists pipo
  [[ $status -eq 0 ]]

  run check_dir_repos not_exists pipo
  [[ $status -eq 1 ]]

  run check_dir_repos dummy pipo
  [[ $status -eq 2 ]]
  [[ -z "$output" ]]

  cleanup
}
