# `mygit_manager`

manage your personal git repos

code inspired from
https://github.com/agateau/reposetup

## LICENCE

GPLv3

## Install

~~~
git clone mygit_manager
cd mygit_manager
./mygit_manager init
~~~

## Usage

Add a repos (same behavior)
~~~
mygit_manager add REPOS_NAME
mygit_manager create REPOS_NAME
~~~

List repos

~~~
mygit_manager list
~~~

remove a repos

~~~
mygit_manager rm REPO_NAME
~~~

## See Also

* https://www.linux.com/learn/how-run-your-own-git-server - installing git server and gitlab
* https://github.com/agateau/reposetup - bash
* https://github.com/robertwahler/repo_manager - ruby

## some commands

~~~
LANG=C git pull github master
git pull github master --allow-unrelated-histories
for d in $(find . -name .git) ; do dd=$(dirname $d); pushd $dd; git remote -v; popd > /dev/null; done | grep -B1 '(fetch)' | grep -B1 repos/git
~~~
