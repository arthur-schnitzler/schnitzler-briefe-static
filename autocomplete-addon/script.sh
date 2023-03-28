# bin/bash

projectdir="html"
inputdir="${projectdir}/static-search/stems"
outputdir="${projectdir}/autocomplete-addon"
filename="auden.txt"

if [ -f $outputdir/$filename ]
    then
        echo "$outputdir/$filename already exists; delete"
        rm -f "$outputdir/$filename"
fi

if [ -d $inputdir ]
    then
        echo "create file: $filename"
        touch "$outputdir/$filename"
        echo "open inputdir: $inputdir"
        for file in $inputdir/*.json; do
            echo $file | sed -e "s_${projectdir}/__g" >> $outputdir/$filename
        done
        echo "$filename in $outputdir created"
    else
        echo "directory with stems not found! check variables: projectdir, inputdir, outputdir and filename!"
fi