#!/bin/bash

{

# Exit on error
set -o errexit
set -o errtrace

# Constants
openscad="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
timestamp=$(git log -n1 --date=unix --format="%ad" openscad)
commit_hash=$(git log -n1 --format="%h" openscad)

# Flags
bonk=
prefix="oskitone-apc"
dir="local/3d-models/$prefix-$timestamp-$commit_hash"
query=

# Internal variables
_found_matches=

function help() {
    echo "\
Renders APC STL models.

Usage:
./make_stls.sh [-h] [-b] [-p PREFIX] [-d DIRECTORY] [-q COMMA,SEPARATED,QUERY]

Usage:
./make_stls.sh                    Export all STLs
./make_stls.sh -h                 Show this message and quit
./make_stls.sh -b                 Bonk and open folder when done
./make_stls.sh -p <prefix>        Set filename prefix
                                  Default is 'oskitone-apc'
./make_stls.sh -d <directory>     Set output directory
                                  Default is local/3d-models/<prefix>...
./make_stls.sh -e                 Echo out output directory and quit
./make_stls.sh -c                 Echo out commit hash and quit
./make_stls.sh -q <query>         Export only STLs whose filename stubs match
                                  comma-separated query

Examples:
./make_stls.sh -p test -q switch  Exports test-...-switch_clutch.stl
./make_stls.sh -p wheels,enc      Exports oskitone-apc-...-wheels.stl,
                                  oskitone-apc-...-enclosure_bottom.stl,
                                  and oskitone-apc-...-enclosure_top.stl
"
}

function note_poly555_branch() {
    pushd ../poly555 > /dev/null
    poly555_branch=$(git branch --show-current)
    popd > /dev/null

    echo "NOTE: poly555 is on branch '$poly555_branch'."
    echo
}

function export_stl() {
    stub="$1"
    override="$2"
    flip_vertically="$3"

    function _run() {
        filename="$dir/$prefix-$timestamp-$commit_hash-$stub.stl"

        echo "Exporting $filename..."

        # The "& \" at the end runs everything in parallel!
        $openscad "openscad/apc.scad" \
            --quiet \
            -o "$filename" \
            --export-format "binstl" \
            -D 'SHOW_ENCLOSURE_TOP=false' \
            -D 'SHOW_ENCLOSURE_BOTTOM=false' \
            -D 'SHOW_PCB=false' \
            -D 'SHOW_WHEELS=false' \
            -D 'SHOW_SWITCH_CLUTCH=false' \
            -D 'SHOW_BATTERY=false' \
            -D 'SHOW_DFM=true' \
            -D 'WHEELS_COUNT=1' \
            -D "CENTER=true" \
            -D "FLIP_VERTICALLY=$flip_vertically" \
            -D "$override=true" \
            & \
    }

    if [[ -z "$query" ]]; then
        _run
    else
        for query_iterm in "${query[@]}"; do
            if [[ "$stub" == *"$query_iterm"* ]]; then
                _found_matches=true
                _run
            fi
        done
    fi
}

function create_zip() {
    if [[ -z "$query" ]]; then
        echo
        echo "Creating zip"
        pushd $dir
        zip "$prefix-$timestamp-$commit_hash-ALL.zip" *.stl
        popd > /dev/null
    fi
}

function run() {
    mkdir -pv $dir

    function finish() {
        # Kill descendent processes
        pkill -P "$$"
    }
    trap finish EXIT

    note_poly555_branch

    start=`date +%s`

    export_stl 'enclosure_bottom' 'SHOW_ENCLOSURE_BOTTOM' 'false'
    export_stl 'enclosure_top' 'SHOW_ENCLOSURE_TOP' 'true'
    export_stl 'switch_clutch' 'SHOW_SWITCH_CLUTCH' 'false'
    export_stl 'wheels' 'SHOW_WHEELS' 'false'
    wait

    end=`date +%s`
    runtime=$((end-start))

    if [[ "$query" && -z $_found_matches ]]; then
        echo "Found no matches for query '$query'"
    else
        create_zip

        if [[ $bonk ]]; then
            printf "\a"
            open $dir
        fi
    fi

    echo
    echo "Finished in $runtime seconds"
}

while getopts "h?b?p:d:e?c?q:" opt; do
    case "$opt" in
        h) help; exit ;;
        b) bonk=true ;;
        p) prefix="$OPTARG" ;;
        d) dir="$OPTARG" ;;
        e) echo "$dir"; exit ;;
        c) echo "$commit_hash"; exit ;;
        q) IFS="," read -r -a query <<< "$OPTARG" ;;
        *) help; exit ;;
    esac
done

run "${query[@]}"

}
