#!/bin/bash
# verification de la typo des fichiers de traduction BLFS
# Denis Mugnier Janvier 2012
# myou72@orange.fr
# les fichiers fran�ais sont sous ./
# l'option -q permet de limiter les sorties � l'�cran
# auteur : Denis Mugnier
# Pour me contacter : myou72@orange.fr
# ou sur le canal IRC #lfs-fr sur irc.freenode.net
#
# Fichier sous licence CC-BY-SA
# 11/03/12


#recherche des fichiers xml dans listxml

for i in $(cat listxml)
do
  if [[ $1 != "-q" ]]
  then
    echo $i # affichage du fichier en cours
  fi
  if cat $i | grep -q " :"
  then
     sed -e 's/ :/\&nbsp;:/g' -i $i
     sed -e 's/>:/>\&nbsp;:/g' -i $i
  fi
  sed -e 's/\(<!ENTITY.* [KMG]\)B/\1io/g' -i $i
  sed -e 's/^[+-]//g' -i $i
done
exit 0
 
