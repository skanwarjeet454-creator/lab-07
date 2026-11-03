for i in 1 2 3 4; do
    dir="Testcase$i"              # e.g. Testcase3
    outdir="Testcase${i}Diff"     # e.g. Testcase3Diff

    rm -rf "$outdir"              # delete old results so every run is the same

    for f in "$dir"/*.1.txt; do
        name=$(basename "$f" .1.txt)   # Testcase3/Version3.1.txt -> Version3
        f2="$dir/$name.2.txt"          # partner file: Testcase3/Version3.2.txt

        # diff succeeds (exit 0) if the files are the same, fails if they differ
        if ! diff -u "$f" "$f2" > /dev/null; then
            mkdir -p "$outdir"                         # make the box only when needed
            diff -u "$f" "$f2" > "$outdir/${name}Diff.txt"   # save the differences
        fi
    done
done
