#!/bin/bash
# conversion des fichiers de listxml en iso-8859-15
#
# auteur : Denis Mugnier
# Pour me contacter : myou72@orange.fr
# ou sur le canal IRC #lfs-fr sur irc.freenode.net
#
# Fichier sous licence CC-BY-SA
# 11/03/12

# on liste l'ensemble des fichiers de listxml

#initialisation du chemin relatif des logs par rapport a la racine de la copie de travail de la VF
CHEMIN_LOG="./traduc/script/robot-html/log"


for i in $(cat listxml)
do
            # pour les fichiers différents de general.ent qui reste en utf8
           if [[ "$i" != "./general.ent" ]]
           then
              # détermination du format de fichier
              a=$(file -i $i 2>&1 >>$CHEMIN_LOG/robot.err)
              if [[ $? -gt 0 ]]
              then
                 exit 1
              fi
              a=$(echo $a | awk -F "=" '{ print $2 }' 2>&1 >>$CHEMIN_LOG/robot.err)
	      if [[ $? -gt 0 ]]
              then
                 exit 1
              fi
              # si c'est pas un iso-8859 et si c'est pas un binaire
              if [[ "$a" != "iso-8859-1" && "$a" != "binary" ]]
		then
			if [[ $1 != "-q" ]]
			then
			  echo "conversion de $i ($a vers iso-8859-15)"
			fi
                        iconv -f $a -t iso-8859-15 $i > $i.temp 2>>$CHEMIN_LOG/robot.err
                        if [[ $? -gt 0 ]]
                        then
                           exit 1
                        fi
			mv $i.temp $i 2>&1 >>$CHEMIN_LOG/robot.err
                        if [[ $? -gt 0 ]]
                        then
                           exit 1
                        fi
		fi
	   fi
         
    

done

exit 0