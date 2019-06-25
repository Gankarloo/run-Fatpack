#!/bin/bash

# firts argument should be the perl app
APP=$1
# Make sure we are in the same DIR as the script. (should be the project root)
scriptdir=$(dirname "$(readlink -f "$0")")
cd $scriptdir

# Are we in a Git worktree?
if git rev-parse --is-inside-work-tree 2>&1 > /dev/null
then
    echo "Yes we got an Git worktree"
    # Do we have App::Cpm as a submodule?
    run=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
    if [[ "$run" =~ "cpm" ]]
    then
        echo "we have cpm as a submodule"
        echo "Update cpm"
        git submodule update --init

    else
        echo "cannot find cpm, adding as a submodule"
    fi
    # run cpm to download all dependencies
    echo "Download deps"
    perl cpm/cpm install -L local --target-perl 5.14.0

    #Set perl library path to ONLY the current project
    export PERL5LIB=$PWD/lib:$PWD/local/lib/perl5
    # Prepend project to path
    export PATH=$PWD/local/bin:$PATH

    # Check perl app for compile errors, if any exit.
    echo "Check for compile errors"
    perl -c $APP || exit 1

    # Cleanup
    echo "Cleanup"
    trap 'rm -rf .build fatlib fatpacker.trace fatpacker.trace.bak packlists' EXIT

    # Begin Fatpacking
    echo "Fatpack trace"
    fatpack trace $APP
    echo "Fatpack packlists-for"
    fatpack packlists-for $(cat fatpacker.trace) > packlists
    echo "Fatpack tree"
    fatpack tree $(cat packlists)
    # Remove all files not a perl module
    echo "Remove all non .pm files in fatlib/"
    find fatlib -type f ! -name '*.pm' -delete
    # Make it smaller
    echo "Run perlstrip on all modules"
    find fatlib -type f -exec perlstrip -v {} \;
    # Final fatpack to single file
    echo "Fatpack the file"
    fatpack file $APP > ${APP%.*}.packed.pl
else
    echo "not in a git worktree"
    echo "TODO: download cpm file from github."
fi

