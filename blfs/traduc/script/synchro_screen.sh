#!/bin/bash

#find ./blfs-fr -name "*.xml" > listfr
sed -i listfr -e "/sheets/d" -e "/archive/d"
sed -i listfr -e "s@./blfs-fr/@@g"

for fichier in $(cat listfr)
do
echo $fichier
fen="./blfs-en/BOOK/$fichier"
ffr="./blfs-fr/$fichier"

nom=$(basename $fichier)

echo $fen
echo $ffr
echo $nom

cp $fen ./$nom.en
cp $ffr ./$nom.fr

iconv -f iso-8859-1 -t utf-8 -o ./$nom.en.tmp ./$nom.en
mv ./$nom.en.tmp ./$nom.en 
iconv -f iso-8859-1 -t utf-8 -o ./$nom.fr.tmp ./$nom.fr
mv ./$nom.fr.tmp ./$nom.fr

sed -i $nom.en -e "s/<!--/\n<!--\n/g" -e "s/-->/\n-->\n/g"
sed -i $nom.fr -e "s/<!--/\n<!--\n/g" -e "s/-->/\n-->\n/g"

sed -i $nom.en -e "/<!--/,/-->/d"
sed -i $nom.fr -e "/<!--/,/-->/d"

sed -i $nom.en -e "s/\(<screen[^>]*>\)/\n\1\n/g"
sed -i $nom.fr -e "s/\(<screen[^>]*>\)/\n\1\n/g"

sed -i $nom.en -e "s/\(<.screen>\)/\n\1\n/g"
sed -i $nom.fr -e "s/\(<.screen>\)/\n\1\n/g"

sed -ne "/<screen/,/screen>/p" $nom.en > $nom.en.screen
old_IFS=$IFS
IFS=$'\n'
i=1
for ligne in $(cat ./$nom.en.screen)
do
  echo $ligne >> ./$nom.en.screen.$i
  if [[ $ligne == "</screen>" ]]
  then
	let "i += 1"
  fi
done
i=1
w="ok" 
for ligne in $(cat "./${nom}.fr")
do
   if [[ ${ligne:0:7} == "<screen" ]]
   then
      w="nok"
      cat $nom.en.screen.$i >> $nom.fr.new
      let "i += 1"
   fi
   if [[ $w == "ok" ]]
   then
     echo "$ligne" >> $nom.fr.new
   fi
   if [[ $ligne == "</screen>" ]]
   then
      w="ok"
   fi
done
IFS=$old_IFS

iconv -f utf-8 -t iso-8859-1 -o $ffr $nom.fr.new
rm $nom.*
done


exit 0
