#!/bin/bash
# verification de la typo des fichiers de traduction BLFS
# Denis Mugnier Janvier 2012
# myou72@orange.fr
# les fichiers français sont sous ./
# l'option -q permet de limiter les sorties à l'écran
# auteur : Denis Mugnier
# Pour me contacter : myou72@orange.fr
# ou sur le canal IRC #lfs-fr sur irc.freenode.net
#
# Fichier sous licence CC-BY-SA
# 11/03/12
# initialisation du chemin pour blfs-fr
CHEMIN_BLFSFR="/mnt/travail/blfs-fr"

# on se déplace à la racine de la copie de travail de BLFS-fr
cd $CHEMIN_BLFSFR

#recherche des fichiers xml dans listxml

for i in $(cat $CHEMIN_BLFSFR/listxml)
do
  i=$CHEMIN_BLFSFR$( echo $i | sed -e "s@^\.*@@g")
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
  sed -e 's/^+//g' -i $i
  
done
exit 0
 
