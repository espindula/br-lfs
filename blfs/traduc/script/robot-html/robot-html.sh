#!/bin/bash
#
# Robot de génération automatique du html de BLFS
# et effectuant différentes vérifications/modifications.
#
# Le compte rendu est envoyé sur la ML LFS en cas de problèmes de construction.
# Le fichier mail.txt contient le compte rendu du dernier travail fait par le robot.
#
# Le robot effectue les tâches suivantes :
#     - vérification de la concordance du nombre de balises entre VO et VF (un nb de balises différentes
# peut indiquer un pb dans le fichier VF
#     - modification des champs $date et $LastChangedBy dans la VF pour synchroniser les informations de la VO.
#     - ajout des espaces insécables devant ":",
#     - correction de KB,MB et GB en Kio, Mio et Gio
#     - Suppression des "+" ou des "-" en début de ligne
#     - conversion des fichiers utf-8 en iso8859-15
#     - validation de la compilation du XML
#     - construction de la version HTML du livre et de l'archive tar.bz2
#     - publication sur le site de la version HTML et de l'archive tar.bz2
#
# IMPORTANT : pour fonctionner correctement, le robot doit rester dans le répertoire
# <copie de travail blfs-fr>/traduc/script/robot-html/
# Il est prévu que la copie de travail blfs-fr s'appelle blfs-fr
# et il faut également une copie de travail du dépôt svn://svn.linuxfromscratch.org/BLFS/trunk
# dans un répertoire appelé blfs-en.
# Le script doit exécuté avec un utilisateur ayant les droits d'écriture sur l'ensemble des répertoires
# du dépot blfs-fr et les droits de lecture des répertoires du dépôt blfs-en
#
# Pour fonctionner correctement, les logs des commits sur blfs-fr doivent contenir le numéro
# de la dernière VO traduite.
# svn commit -m "jusqu'a 10200" est ok si 10200 est la dernière VO traduite
# svn commit -m "blablabla 10200 blablabla" est ok si 10200 est la dernière VO traduite
# svn commit -m "synchro avec la VO" n'est PAS OK
# svn commit -m "traduction de 10200 et maintenant j'attends 10300 pour travailler" n'est pas OK. Il ne faut
#                 pas indiquer d'autre numéro de VO que la dernière traduite
#
# Dépendances d'exécution :
#    - script fonctionnant sous bash
#    - grep
#    - wget
#    - svn
#    - sed
#    - rsync
#
# code de sortie du script :
#   0 : Le script c'est terminé correctement
#   1 : Erreur, voir le fichier $CHEMIN_LOG/robot.log
#
# fichiers de log
# $CHEMIN_LOG/robot.log : log de la dernière exécution du robot
# $CHEMIN_LOG/robot.err : erreurs dans la dernière exécution du robot
# $CHEMIN_LOG/jobrobot.log :journal des exécutions du robot
# $CHEMIN_LOG/robot.rapport : rapport de la dernière exécution du robot
#
# auteur : Denis Mugnier
# Pour me contacter : myou72@orange.fr
# ou sur le canal IRC #lfs-fr sur irc.freenode.net
#
# Fichier sous licence CC-BY-SA
# 11/03/12
# initialisation de la variable avec l'adresse mail de l'admin du robot
# les log d'erreurs sont envoyés à l'admin du robot
ADMIN_ROBOT="myou72@orange.fr"
# initialisation du chemin pour blfs-fr
CHEMIN_BLFSFR="/home/denis/blfs-fr"
#initialisation du chemin relatif des logs par rapport a la racine de la copie de travail de la VF
CHEMIN_LOG="${CHEMIN_BLFSFR}/traduc/script/robot-html/log"
# fonction pour la gestion des erreurs
# $1 : code d'erreur
# dans le cas d'une erreur, un mail est envoyé à l'admin du robot
function log_err
{
        if [[ $1 -eq "0" ]]
        then
            echo "... OK" >> $CHEMIN_LOG/robot.log
        else
            echo "... Echec" >> $CHEMIN_LOG/robot.log
            echo "... Echec" >> $CHEMIN_LOG/jobrobot.log
            cat $CHEMIN_LOG/robot.log >$CHEMIN_BLFSFR/mail.err
            cat $CHEMIN_LOG/robot.err >>$CHEMIN_BLFSFR/mail.err
            cat $CHEMIN_BLFSFR/mail.err | mail -s "Echec du robot" -t $ADMIN_ROBOT -a From:"Robot HTML <$ADMIN_ROBOT>" -a 'Content-Type: text/plain; charset="utf8"' -a "MIME-Version: 1.0"
            exit 1
        fi
}
function log_att
{
        if [[ $1 -eq "0" ]]
        then
            echo "   ... OK" >> $CHEMIN_LOG/robot.log
        else
            echo "   ... Echec" >> $CHEMIN_LOG/robot.log
        fi
}
# fonction pour loguer une info
function log_info
{
         echo -n $(date) : $1 >> $CHEMIN_LOG/robot.log
}
# variable numérique utilisée dans le script
declare -i VERSION 
declare -i V_FR        # version de la dernière VF publiée
declare -i V_WIKI      # dernière VO indiquée traduite sur le wiki
declare -i V_ANC       # dernière VF traitée par le robot
declare -i V_FRACT     
# on se déplace à la racine de la copie de travail de BLFS-fr
cd $CHEMIN_BLFSFR
# initialisation de $CHEMIN_LOG/robot.log
> $CHEMIN_LOG/robot.log
> $CHEMIN_LOG/robot.err
log_info "Démarrage du robot"
log_err $?
echo -n "$(date) Exécution du robot" >> $CHEMIN_LOG/jobrobot.log
# initialisation de la dernière version traduite par le robot
# l'information est enregistrée dans le fichier ./vtraduc
log_info "initialisation dernière VF traîtée "
V_ANC=0
V_ANC=$(cat $CHEMIN_BLFSFR/vtraduc)
log_att $?
#---------------------------------------------------------------------
# détermination de la dernière version traduite selon le wiki
#---------------------------------------------------------------------
# récupération de la page du wiki et enregistrement dans blfsfr
log_info "Chargement de la page du wiki"
wget http://traduc.org/blfsfr 2>>$CHEMIN_LOG/robot.err
log_err $?
# extraction de toutes les lignes contenant un numéros de 5 chiffres dans le fichier list
log_info "Recherche des numéros de 5 chiffres dans la page du wiki"
grep \>\*[0-9][0-9][0-9][0-9][0-9] blfsfr >list
log_err $?
V_WIKI=0
# suppression des balises html de list et ajout d'un \n après chaque numéro à 5 chiffres
log_info "Nettoyage dans le fichier list"
sed -e "s/>/>\n/g" -i list
sed -e "s/<.*>//g" -e "s/\([0-9][0-9][0-9][0-9][0-9]\)/\n\1\n/g" -e "/^$/d" -i list 2>>$CHEMIN_LOG/robot.err
log_err $?
# parcourt du fichier list, extraction du nb à 5 chiffres de la ligne et
# détermination du plus grand
log_info "recherche du numéro de la dernière VO traduite dans le wiki"
while read LIGNE
do
   V=$(echo $LIGNE | sed 's/.*\([0-9][0-9][0-9][0-9][0-9]\).*/\1/g')
   if [[ $V > $V_WIKI ]]
   then
      let V_WIKI=$V
   fi
done < list
if [[ $V_WIKI == 0 ]]
then
   echo "Aucune VO traduite trouvée sur le wiki" >>$CHEMIN_LOG/robot.err
   log_err 1
else
   log_err 0
fi
log_info "version $V_WIKI indiquée sur le wiki comme étant la dernière traduite"
log_err 0
# effacement des fichiers blfsfr et list
rm blfsfr
rm list
#---------------------------------------------------------------------
# Détermination de la liste des fichiers modifiés entre la version de
# travail du dépôt et la dernière version sur le dépôt.
# Les vérifications ne porteront que sur ces fichiers.
# On ajoute également a la liste, la liste des derniers fichiers étant
# connus pour avoir un pb de concordance.
#---------------------------------------------------------------------
log_info "Recherche de la liste des fichiers modifiés sur le dépôt depuis la dernière visite du robot"
svn diff -r BASE:HEAD | grep -v "traduc/commits" | grep Index | sed -e '/^[+-]Index/d' | sed -e 's/Index: /.\//g' > $CHEMIN_BLFSFR/listxml 2>>$CHEMIN_LOG/robot.err
log_err $?
log_info "Ajout de la liste des fichiers de verif.lst"
sed -e 's/^\(.*\) :.*/\1/g' verif.lst >>$CHEMIN_BLFSFR/listxml 2>>$CHEMIN_LOG/robot.err
sed -e "/archive/d" -i listxml
log_att $?
# synchronisation de la copie de travail avec le dépôt
log_info "synchronisation de la copie de travail avec le dépôt"
svn up 2>>$CHEMIN_LOG/robot.err
log_err $?
#---------------------------------------------------------------------
# Détermination du numéro de la dernière VO ayant été traduite
#---------------------------------------------------------------------
log_info "détermination des infos de la copie de travail"
INFO=$(svn info 2>>$CHEMIN_LOG/robot.err)
log_err $? 
# initialisation de V_FRACT avec le numéro de la version courante de blfs-fr
#V_FRACT=$(echo $INFO | sed -re 's/.*Révision : ([0-9][0-9]*).*/\1/')
LOG="------------------------------------------------------------------------"
#while [[ $LOG == "------------------------------------------------------------------------" ]]
#do
#   LOG=$(svn -c $V_FRACT log )
#   if echo $LOG | grep -qF "[BLFS-EN]"
#   then
#      LOG="------------------------------------------------------------------------"
#   fi
#   V_FRACT=$V_FRACT-1
#done
V_EN=0
#V_FR=$(echo $LOG | sed 's/.*r\([0-9][0-9]*\).*/\1/g')
V_FR=$(echo $INFO | sed -e 's/^.*vision.:.\([0-9][0-9][0-9][0-9]\).*$/\1/')
VERSION=$V_FR+1
# on cherche tant qu'on n'a pas trouvé un numéro de VO
log_info "recherche de la dernière VO traduite publiée sur le dépôt"
while [[ $V_EN == 0 && $VERSION != "1" ]]
do
   VERSION=$VERSION-1
   # extraction du log de la version de blfs-fr examinée
   LOG=$(svn -c "$VERSION" log 2>>$CHEMIN_LOG/robot.err)
   if [[ $? -gt 0 ]]
   then
      log_err $?
   fi
   # si c'est une version postée par le robot de traduction, on continue de chercher
   if echo $LOG | grep -qF "[BLFS-EN]"
   then
      continue
   fi
   # si la modification concerne un autre dépôt, on continue de chercher
   if [[ $LOG == "------------------------------------------------------------------------" ]]
   then
      continue
   fi
   # effacement de LOG du nombre de lignes
   LOG=$(echo $LOG | sed -e 's/[0-9] li//g' 2>>$CHEMIN_LOG/robot.err)
   if [[ $? -gt 0 ]]
   then
      log_err $?
   fi
   # effacement de LOG de ce qui n'est pas un chiffre, des caractères [] et /,
   LOG=$(echo $LOG | cut -d'|' -f4 | tr "[:alpha:][:cntrl:][:punct:]" ' ' | sed -e 's/\[//g' -e 's/\]//g'  -e 's@/@@g')
   if [[ $? -gt 0 ]]
   then
      log_err $?
   fi
   # on regarde dans ce qui reste dans LOG pour trouver le plus grand chiffre qui sera le numéro de la VO
   # traduite.
   # IMPORTANT les log de commit ne doivent pas contenir de nb de 5 chiffres qui ne corresponde pas à la dernière
   # VO traduite
   for i in $LOG
   do
      if [[ "$i" -gt "$V_EN" ]]
      then
         if [[ "$i" -gt "10000" ]]
	then
           let V_EN=$i
         fi
      fi
   done
done
# si on a rien trouvé, on sort du script
if [[ $VERSION == "1" ]]
then
   echo "Pas de version traduite trouvée" >> $CHEMIN_LOG/robot.err
   log_err 1
fi
log_err $?
# on a trouvé un numéro VO traduite, on continue.
log_info "la dernière version traduite publiée est $V_EN"
log_err 0
echo "Bonjour," > $CHEMIN_BLFSFR/mail.txt 2>>$CHEMIN_LOG/robot.err
echo >>$CHEMIN_BLFSFR/mail.txt
# synchro de la copie de travail angaise a la dernière version traduite
log_info "Examen de la copie de travail de blfs-en"
cd ../blfs-en/ 2>>$CHEMIN_LOG/robot.err
log_err $?
log_info "Synchro de la copie de travail de blfs_en à la version $V_EN"
svn -r "$V_EN" up 2>>$CHEMIN_LOG/robot.err
log_err $?
cd ../blfs-fr/
pbxml="0"
# on vérifie la concordance
log_info "traîtement des concordances"
#./traduc/script/robot-html/verif.sh -q 2>>$CHEMIN_LOG/robot.err
log_err $?
# si la dernière version traduite est également la dernière version traîtée par le robot
# alors il n'y a rien a faire
if [[ $VERSION == $V_ANC ]]
then
   log_info "Le robot a trouvé que la dernière version traduite est déjà en ligne"
   log_err 0
   log_info "rédaction du rapport"
   echo "Aucun changement sur le SVN depuis ma dernière visite. Alors j'ai rien a faire." >> $CHEMIN_BLFSFR/mail.txt
   echo >>$CHEMIN_BLFSFR/mail.txt
   echo "bonne journée !">>$CHEMIN_BLFSFR/mail.txt
   echo >>$CHEMIN_BLFSFR/mail.txt
   echo "Denis_ROBOT">>$CHEMIN_BLFSFR/mail.txt
   echo >>$CHEMIN_BLFSFR/mail.txt
   echo "Il faudrait analyser les fichiers suivants car le nombre de balises entre le français et l'anglais n'est pas concordant (un nombre négatif indique des balises manquantes dans la version française alors qu'un nombre positif indique des balises en trop) :" >>$CHEMIN_BLFSFR/mail.txt
   cat verif.lst >>$CHEMIN_BLFSFR/mail.txt
   mv $CHEMIN_BLFSFR/mail.txt $CHEMIN_LOG/robot.rapport
   log_err $?
# si la version indiquée sur le wiki n'est pas la dernière version publiée
elif [[ $V_WIKI != $V_EN ]]
   then
      log_info "Le robot pense qu'une version est en cours de traduction"
      log_err 0
      log_info "rédaction du rapport"
      echo "Je pense qu'une traduction est en cours, donc je ne fais rien (sinon je vais faire des bêtises :o) )." >>$CHEMIN_BLFSFR/mail.txt
      echo >>$CHEMIN_BLFSFR/mail.txt
      echo "Version la plus récente en cours de traduction : $V_WIKI">>$CHEMIN_BLFSFR/mail.txt
      echo "Version anglaise sur le SVN : $V_EN">>$CHEMIN_BLFSFR/mail.txt
      echo >>$CHEMIN_BLFSFR/mail.txt
      echo "Bonne journée et bonne traduction !">>$CHEMIN_BLFSFR/mail.txt
      echo >>$CHEMIN_BLFSFR/mail.txt
      echo "Denis_ROBOT">>$CHEMIN_BLFSFR/mail.txt
      echo >>$CHEMIN_BLFSFR/mail.txt
      echo "Il faudrait analyser les fichiers suivants car le nombre de balises entre le français et l'anglais n'est pas concordant (un nombre négatif indique des balises manquantes dans la version française alors qu'un nombre positif indique des balises en trop) :" >>$CHEMIN_BLFSFR/mail.txt
      cat $CHEMIN_BLFSFR/verif.lst >>$CHEMIN_BLFSFR/mail.txt
      mv $CHEMIN_BLFSFR/mail.txt $CHEMIN_LOG/robot.rapport
      log_err $?      
   else
# sinon il y a eu une nouvelle version de publiée   
      log_info "une nouvelle VF est présente sur le dépôt"
      log_err 0
      if [[ -e tmp ]]
      then
         rm -rf tmp
      fi
      # mise à jour des champs date et contributeur
      log_info "vérification des champs date et contributeur"
 #     ./traduc/script/robot-html/maj-date-contrib.sh  2>>$CHEMIN_LOG/robot.err
      log_err $?
      # correction de typo
      log_info "correction sur le fichiers xml"
 #    ./traduc/script/robot-html/typo.sh -q 2>>$CHEMIN_LOG/robot.err
      log_err $?
      # on regarde la validité du xml
      log_info "validation du xml"
      make validate > validation.txt 2>&1
      log_att $?
      nb_ligne=$(cat validation.txt | wc -l)
      echo "La dernière version anglaise traduite est la :" $V_EN >>$CHEMIN_BLFSFR/mail.txt
      echo >>$CHEMIN_BLFSFR/mail.txt
      # si pas de problèmes à la validation le fichier validation.txt n'aura qu'une seule ligne
      if [[ $nb_ligne == "1" ]]
      then
         # on construit la version html
         log_info "construction du html"
         make html BASEDIR=./blfs-svn 2>>$CHEMIN_LOG/robot.err
         log_err $?
         cd blfs-svn
         # on construit le fichier d'archive
         log_info "construction de l'archive tar.bz2"
         tar -cjf blfs-svn.tar.bz2 * 2>>$CHEMIN_LOG/robot.err
         log_err $?
         cd ..
         log_info "déplacement de l'archive à la racine"
         mv ./blfs-svn/blfs-svn.tar.bz2 ./ 2>>$CHEMIN_LOG/robot.err
         log_err $?
         log_info "modification des droits de l'archive"
         chmod -R a+w blfs-svn.tar.bz2 2>>$CHEMIN_LOG/robot.err
         log_att $?
         echo "Le xml est ok et le html est également correctement construit." >>$CHEMIN_BLFSFR/mail.txt
         log_info "récupération de la liste des modifications faites par le robot"
         svn diff > diff.txt 2>>$CHEMIN_LOG/robot.err
         log_att $?
         if [[ -s "diff.txt" ]]
         then
            echo >>mail.twt
            echo "J'ai modifié des fichiers (voir mon commit)" >>$CHEMIN_BLFSFR/mail.txt
         fi
         log_info "publication sur le dépôt des modifications faites par le robot"
         svn commit -m "correction par le robot" 2>>$CHEMIN_LOG/robot.err
         log_err $?
         log_info "modification des droits dans les fichiers HTML"
         chmod -R a+w blfs-svn 2>>$CHEMIN_LOG/robot.err
         log_err $?
         if [[ -s "verif.lst" ]]
         then
            echo >>$CHEMIN_BLFSFR/mail.txt
            echo "Il faudrait analyser les fichiers suivants car le nombre de balises entre le français et l'anglais n'est pas concordant (un nombre négatif indique des balises manquantes dans la version française alors qu'un nombre positif indique des balises en trop) :" >>$CHEMIN_BLFSFR/mail.txt
            cat verif.lst >>$CHEMIN_BLFSFR/mail.txt 
         fi
         log_info "publication de la version HTML sur le site traduc.org"
         rsync $1 -lrugop --delete blfs-svn traduc.org:/home/traduc.org/www/lfs.traduc.org/view/ 2>&1 2>>$CHEMIN_LOG/robot.err
         log_err $?
         log_info "publication de l'archive sur le site traduc.org"
         rsync $1 -lrugop --delete blfs-svn.tar.bz2 traduc.org:/home/traduc.org/www/lfs.traduc.org/archives/blfs-svn/ 2>&1 2>>$CHEMIN_LOG/robot.err
         log_err $?
         log_info "suppression du rep blfs-html"
         rm -r blfs-html 2>>$CHEMIN_LOG/robot.err
#         log_err $?
         log_info "déplacement de la version HTML que l'on vient de construire dans blfs-html"


         mv blfs-svn blfs-html 2>>$CHEMIN_LOG/robot.err
         log_err $?
         if [[ -e tmp ]]
         then
            rm -r tmp
         fi
         echo >>$CHEMIN_BLFSFR/mail.txt
         echo "bonne journée" >>$CHEMIN_BLFSFR/mail.txt
         echo "Denis_ROBOT" >>$CHEMIN_BLFSFR/mail.txt
         if [[ -s "verif.lst" ]]
         then
            echo >>$CHEMIN_BLFSFR/mail.txt
            echo "Détail des balises :">>$CHEMIN_BLFSFR/mail.txt
            cat verif.detail >>$CHEMIN_BLFSFR/mail.txt
         fi
         echo >>$CHEMIN_BLFSFR/mail.txt
         mv $CHEMIN_BLFSFR/mail.txt $CHEMIN_LOG/robot.rapport
         # enregistrement de la version traduite
         log_info "enregistrement de la version traduite"
         echo $V_FR > vtraduc
         log_err $?  
      else
         # si le XML ne valide pas
         pbxml="1"
         echo "Le xml n'est pas ok. Le html n'est pas construit." >>$CHEMIN_BLFSFR/mail.txt
         echo >>$CHEMIN_BLFSFR/mail.txt
         cat validation.txt >>$CHEMIN_BLFSFR/mail.txt
         echo >>$CHEMIN_BLFSFR/mail.txt
         echo "bonne journée et bon déboguage XML !! ;o)">>$CHEMIN_BLFSFR/mail.txt
         echo "Denis_ROBOT">>$CHEMIN_BLFSFR/mail.txt
      fi
fi
if [[ "$pbxml" == "1" ]]
then
   mv $CHEMIN_BLFSFR/mail.txt.temp $CHEMIN_BLFSFR/mail.txt
   log_info "envoi du mail à la ML pour indiquer un pb avec le XML"
   cat $CHEMIN_BLFSFR/mail.txt | mail -s "PB XML" -t lfs-traducfr@linuxfromscratch.org -a From:"Robot HTML <$ADMIN_ROBOT>" -a 'Content-Type: text/plain; charset="iso-8859-1"' -a "MIME-Version: 1.0" 2>>$CHEMIN_LOG/robot.err
   log_att $?
   log_info "envoi du mail à l'admin du robot"
   cat $CHEMIN_BLFSFR/mail.txt | mail -s "PB XML" -t $ADMIN_ROBOT -a From:"Robot HTML <$ADMIN_ROBOT>" -a 'Content-Type: text/plain; charset="iso-8859-1"' -a "MIME-Version: 1.0" 2>> $CHEMIN_LOG/robot.err
   log_att $?
fi
# si on est lundi, on envoi un rapport de concordance sur la ML
dat=$(date)
if [[ "${dat:0:3}" == "lun" ]]
then
   if [[ -s "verif.lst" ]]
         then
            echo >$CHEMIN_BLFSFR/mail.txt
            echo "Détail des balises :">>$CHEMIN_BLFSFR/mail.txt
            cat verif.detail >>$CHEMIN_BLFSFR/mail.txt
            log_info "envoi mail indiquant la concordance"
            cat $CHEMIN_BLFSFR/mail.txt | mail -s "Validation du html" -t lfs-traducfr@linuxfromscratch.org -a From:"Robot HTML <$ADMIN_ROBOT>" -a 'Content-Type: text/plain; charset="iso-8859-1"' -a "MIME-Version: 1.0" 2>>$CHEMIN_LOG/robot.err
            log_err $?
         fi
fi
#renseignement du log pour la réussite
echo " ... OK" >> $CHEMIN_LOG/jobrobot.log
exit 0
