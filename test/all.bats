#!/bin/bash

@test "init REPO_BASE_DIR" {
	_create_config
	run $mygit_manager init
	[[ -d "$REPO_BASE_DIR " ]]
}
