#1/bin/bash

cd Contest4
for i in $(ls) ; do

cd "$i"
cd Data
mkdir secret
mkdir sample
# for in folder
cd in 
for j in $(ls) ; do 
mv $j $j.in
done
mv *sample*.in ../sample
mv * ../secret
rmdir ../in

# for out folder
cd ../../Data/out
for j in $(ls) ; do 
mv $j $j.ans
done
mv *sample*.ans ../sample
mv * ../secret
rmdir ../out



cd ../..

cd ..
echo "hiiiiii"

done 