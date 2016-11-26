#!/bin/bash

die() {
  echo "${0}:error: $*" >&2
  exit 1
}

fail_if_repo() {
  local repo_name=$2
  local checkp="$REPO_BASE_DIR/$repo_name/branches"
  case $1 in
  exists|exist)
    [[ -d "$checkp" ]] && \
      die "There is already a repository named \"$repo_name\""
    ;;
  not_exists)
    [[ ! -d "$checkp" ]] && \
      die "Repository named \"$repo_name\" is missing"
    ;;
  *)
    die "argument '$1' not supported"
    ;;
  esac
  return 0
}

fail_if_pipo() {
  if [[ "$1" == pipo ]]
  then
    die "got pipo"
  fi
  return 0
}

@test "die exit with 1" {
  run die pipo
  [[ $status -eq 1 ]]
}

@test "fail_if_pipo if statement" {
  run fail_if_pipo molo
  [[ $status -eq 0 ]]
  run fail_if_pipo pipo
  [[ $status -eq 1 ]]
}

REPO_BASE_DIR=./test_status

@test "fail_if_repo exists" {
  mkdir -p $REPO_BASE_DIR
  [[ ! -d $REPO_BASE_DIR/pipo ]]

  run fail_if_repo exists pipo
  [[ $status -eq 0 ]]
  [[ -z "$output" ]]

  git init --bare $REPO_BASE_DIR/pipo
  [[ -d $REPO_BASE_DIR/pipo/branches ]]

  run fail_if_repo exists pipo
  [[ $status -eq 1 ]]
}
