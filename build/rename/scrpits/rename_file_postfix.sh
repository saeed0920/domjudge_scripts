#!/bin/bash
set -e
if [ -e "$1" ]; then
cd "$1"
for i in * ; do
if [ -d "$i" ]; then
echo "$i"
cd "$i"
# check the data folder
if [ -d "Data" ]; then
mv Data data
echo "the Data folder convert to data."
fi

if [ -d "data" ]; then
echo "the data folder is exist"
cd data
else
echo "the data folder is not exist in $i"
continue
fi 

if [ -d "secret" ]; then
# check the secret folder
echo "the secret folder is exist"
elif [ -d "sample" ]; then
# check the sample folder
echo "the sample folder is exist"
else
mkdir secret
mkdir sample
fi
if [ -d "in" ]; then
cd in
for j in * ; do
mv "$j" "$j.in"
done
mv *sample*.in ../sample 2>/dev/null || true
mv * ../secret 2>/dev/null || true
cd ..
rmdir in
if [ -d "../../Data/out" ]; then
cd ../../Data/out
for j in * ; do
mv "$j" "$j.ans"
done
mv *sample*.ans ../sample 2>/dev/null || true
mv * ../secret 2>/dev/null || true
cd ..
rmdir out
fi
done
mv *sample*.ans ../sample
mv * ../secret
rmdir ../out

cd ../..
cd ..
echo "the $i is ok"

done 
# the end of loop
echo complete
else
echo "cant find the file"
exit 0
fi