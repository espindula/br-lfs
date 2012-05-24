#!/bin/bash
# script pour la mise à jour des dates de modifications 
# de la version française de BLFS.
# Les fichiers de la version française sont modifiés par
# les informations contenues dans la version anglaise.
# Cela implique d'avoir une version de travail du svn anglais
# de BLFS
# UTILISATION : maj-date-contrib.sh [-q] [-a]
# L'option -q (quiet ;o) ) permet de limiter les sorties à l'écran
# auteur : Denis Mugnier
# Pour me contacter : myou72@orange.fr
# ou sur le canal IRC #lfs-fr sur irc.freenode.net
#
# Fichier sous licence CC-BY-SA
# 11/03/12

BLFS_EN="../blfs-en/BOOK/"

#initialisation du chemin relatif des logs par rapport a la racine de la copie de travail de la VF
CHEMIN_LOG="./traduc/script/robot\ html/log"


#general.ent est exclu de la vérification
LIST=$(cat listxml | grep -v general.ent)


if echo $* | grep -q "q"
then
   MODE_Q=1
else
   MODE_Q=0
fi

echo "Mise a jour des dates de modifications ..."

# on va parcourir l'ensemble des fichiers XML de l'arborescence de BLFS-fr

for i in $LIST
do
  if [[ "$MODE_Q" -eq "0" ]]
  then
    echo $i
  fi
  j=$BLFS_EN${i:2}

  if [[ -f $i ]]
  then

# pour que le script fonctionne correctement, le fichier doit être en UTF-8

    a=$(file -i $i | awk -F "=" '{ print $2 }')  
	if [ "$a" != "utf-8" ]
	then
		if [[ "$MODE_Q" -eq "0" ]]
		then
		  echo "conversion de " $i "(" $a " vers utf8 )"
		fi
		iconv -f $a -t utf-8 $i > $i.temp 2>>$CHEMIN_LOG/robot.err
		if [[ $? -gt 0 ]]
                then
                   exit 1
                fi
                mv $i.temp $i
	fi
 
#extraction des $Date de la version française et de la version anglaise

    DATE_EN=$(sed -n 's/\(^.*\)\(\$Date: \)\(.*\)\( \$.*\)/\3/p' $j)
    DATE_FR=$(sed -n 's/\(^.*\)\(\$Date\(&nbsp;\)*: \)\(.*\)\( \$.*\)/\4/p' $i)

# si c'est différent, on place les infos de la version anglaise

    if [ "$DATE_EN" != "$DATE_FR" ]
    then
      sed "s/\(\$Date\)\(.*\)\$\(.*\)/\1 : $DATE_EN \$\3/" -i $i
      CHG_EN=$(sed -n 's/\(^.*\)\(\$LastChangedBy: \)\(.*\)\( \$.*\)/\3/p' $j)
      sed "s/\(\$LastChangedBy\)\(.*\)\$\(.*\)/\1 : $CHG_EN \$\3/" -i $i
      if [[ "$MODE_Q" -eq "0" ]]
      then
	echo "Modification du fichier "$i "("$DATE_EN" : "$DATE_FR")"
      fi
    fi

# on remet le fichier en iso-8859-15

    a=$(file -i $i | awk -F "=" '{ print $2 }')  
	if [ "$a" != "iso-8859-1" ]
	then
		if [ "$a" != "binary" ]
		then
			if [[ "$MODE_Q" -eq "0" ]]
			then
			  echo "conversion de " $i "(" $a " vers iso-8859-15"
			fi
			iconv -f $a -t iso-8859-15 $i > $i.temp 2>>$CHEMIN_LOG/robot.err
			if [[ $? -gt 0 ]]
                        then
                          exit 1
                        fi
                        mv $i.temp $i
		fi
	fi
  fi
done
exit 0
