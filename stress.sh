#! /bin/sh
cd tests
echo "Removing provious temporary test files ..."
for i in 0 1 2 3 4 5 6 7 8 9; do
    rm [0-9]*.ar
done
echo "Generating temporary test files ..."
files=*.ar
for file in $files; do
    for i1 in 0 1 2 3 4 5 6 7 8 9; do
        for i2 in 0 1 2 3 4 5 6 7 8 9; do
            for i3 in 0 1 2 3 4 5 6 7 8 9; do
                cp $file $i1$i2$i3$file
                echo "Create file" $i1$i2$i3$file
            done
        done
    done
done
cd ..
make test
cd tests
echo "Removing temporary test files ..."
for i in 0 1 2 3 4 5 6 7 8 9; do
    rm -rf $i*.ar
done
cd ..