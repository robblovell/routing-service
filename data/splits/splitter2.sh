#!/usr/bin/env bash
tail -n +2 $2  | split -a 4 -l $1 - $2_
for file in $2_*
do
    head -n 1 $2  > tmp_file
    cat $file >> tmp_file
    mv -f tmp_file $file
done