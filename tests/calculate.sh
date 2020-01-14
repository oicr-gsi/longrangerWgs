#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# list output files to detect new or missing files
ls -1

# count lines for .csv due to nondeterministic numeric fields
find . \( -iname "*.csv" \) -exec wc -l {} \;

# calculate md5sum for everything but csv and cloupe files
find . \( -iname "*.bam" -o -iname "*.bai" -o -iname "*.bedpe" \) 2>/dev/null -exec md5sum {} \;