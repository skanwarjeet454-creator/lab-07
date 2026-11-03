result=0    # 0 = everything passed so far

for i in 1 2 3 4; do
    dir="Testcase$i"
    outdir="Testcase${i}Diff"
    pass=yes          # assume this Testcase passes until we find a problem
    found_diff=no     # did any pair in this folder differ?

    for f in "$dir"/*.1.txt; do
        name=$(basename "$f" .1.txt)
        f2="$dir/$name.2.txt"
        out="$outdir/${name}Diff.txt"

        if diff -u "$f" "$f2" > /dev/null; then
            # Files are the SAME -> there must be NO output file
            if [ -f "$out" ]; then
                echo "$out should not exist" >&2
                pass=no
            fi
        else
            # Files are DIFFERENT -> output file must exist and be correct
            found_diff=yes
            if [ ! -f "$out" ]; then
                echo "$out is missing" >&2
                pass=no
            else
                expected=$(diff -u "$f" "$f2" | tail -n +3)
                actual=$(tail -n +3 "$out")
                if [ "$expected" != "$actual" ]; then
                    echo "$out has wrong contents" >&2
                    pass=no
                fi
            fi
        fi
    done

    # The Diff folder should exist ONLY if something was different
    if [ "$found_diff" = yes ] && [ ! -d "$outdir" ]; then
        echo "$outdir is missing" >&2
        pass=no
    fi
    if [ "$found_diff" = no ] && [ -d "$outdir" ]; then
        echo "$outdir should not exist" >&2
        pass=no
    fi

    # Print the result for this Testcase
    if [ "$pass" = yes ]; then
        echo "Testcase$i: PASS"
    else
        echo "Testcase$i: FAIL"
        result=1
    fi
done

exit $result
