#!/bin/bash
# validation de la concordance du nb de balises entre VF et VO pour BLFS
#
# la liste des différences est dans verif.list
# la liste complete est dans verif.detail
# l'option -q permet de limiter les sorties à l'écran
#
# auteur : Denis Mugnier
# Pour me contacter : myou72@orange.fr
# ou sur le canal IRC #lfs-fr sur irc.freenode.net
#
# Fichier sous licence CC-BY-SA
# 11/03/12

# initialisation du chemin pour blfs-fr
CHEMIN_BLFSFR="/mnt/travail/blfs-fr"

#initialisation du chemin relatif des logs par rapport a la racine de la copie de travail de la VF
CHEMIN_LOG="$CHEMIN_BLFSFR/traduc/script/robot-html/log"


# on se déplace à la racine de la copie de travail de BLFS-fr
cd $CHEMIN_BLFSFR

# déclaration des variables

declare -i nbfrc # nb de balises corrigé dans les fichiers français ( on enlève le nombre de balise <foreignphrase> )
declare -i nbfr # nb de balises dans les fichiers français
declare -i nbenc # nb de balises corrigé dans les fichiers français ( on enlève le nombre de balise <foreignphrase> )
declare -i nben # nb de balises dans les fichiers français
declare -i diff # différence de balises entre le fichier français et le fichier anglais
declare -i bfr # pour la détermination des erreurs
declare -i ben # pour la détermination des erreurs
declare -i bdiff # pour la détermination des erreurs
declare -i bautre # pour la détermination des erreurs

#liste des balises reconnues

liste_balise="<!DOCTYPE <?dbhtml <sect1info <othername </othername <date </date </sect1info <!ENTITY \
<sect1 <sect2 <sect3 <sect4 </sect1 </sect2 </sect3 </sect4 <para> <parameter </parameter </para> <term </term <envar </envar \
<title </title <bridgehead </bridgehead <itemizedlist <listitem </listitem </itemizedlist <ulink </ulink <note <application \
</application <filename </filename <indexterm </indexterm <primary </primary <screen </screen <userinput \
</userinput <systemitem </systemitem <command </command <emphasis </emphasis <xref \
<varlistentry </varlistentry <option </option <literallayout </literallayout> <xi <replaceable </replaceable <seg </seg"

# appel de la fonction
# balises balises
# retour
# différence fr-en
function balises
{
	bfr=$(cat $i | grep -o $1 | wc -l)
	ben=$(cat $j | grep -o $1 | wc -l)
	bdiff=$bfr-$ben
	if [[ $bdiff != 0 ]]
	then
		echo "balise" $1 ":" $bdiff >> $CHEMIN_BLFSFR/verif.detail
	fi
        bautre=$bautre-$bdiff 
} 

cd ../../

#initialisation du fichier résultat 'list'
> $CHEMIN_BLFSFR/verif.lst
> $CHEMIN_BLFSFR/verif.detail

#recherche des fichiers xml dans listxml
for i in $(cat $CHEMIN_BLFSFR/listxml)
do
  echo $i # affichage du fichier en cours
  echo ${i:2}
  k=$i
  j=$CHEMIN_BLFSFR/"../blfs-en/BOOK/"${i:2} # initialisation du chemin vers le fichier anglais à partir du fichier français
  i=$CHEMIN_BLFSFR$( echo $i | sed -e "s@^\.*@@g")
  cp $j tempen
  cp $i tempfr
  j=tempen
  i=tempfr
  sed -e "s/<!--/\n<!--\n/g" -e "s/-->/\n-->\n/g" -i $i
  sed -e "s/<!--/\n<!--\n/g" -e "s/-->/\n-->\n/g" -i $j
  sed -e "/<!--/,/-->/ {
           d
            }" -i $i  
  sed -e "/<!--/,/-->/ {
           d
            }" -i $j
   nbfr=$(cat $i 2>>$CHEMIN_LOG/robot.err | grep -o "<" | wc -l) #détermination du nombre de balises dans le fichier français
  if [[ $? -gt 0 ]]
  then
     exit 1
  fi
  nben=$(cat $j 2>>$CHEMIN_LOG/robot.err| grep -o "<" | wc -l)   #détermination du nombre de balises dans le fichier anglais
    if [[ $? -gt 0 ]]
  then
     exit 1
  fi
  if [[ $nbfr != $nben ]]  #teste si différence 
  then
    m=$(cat $i | grep -o "<foreign" | wc -l)  #détermination du nombre de balises <foreign dans le fichier français
    n=$(cat $i | grep -o "<acronym" | wc -l) #détermination du nombre de balises <acronyme dans le fichier français
    o=$(cat $i | grep -o "<!--" | wc -l) #détermination du nombre de balises <!-- dans le fichier français
    p=$(cat $j | grep -o "<foreign" | wc -l)  #détermination du nombre de balises <foreign dans le fichier anglais
    q=$(cat $j | grep -o "<acronym" | wc -l) #détermination du nombre de balises <acronyme dans le fichier anglais
    r=$(cat $j | grep -o "<!--" | wc -l) #détermination du nombre de balises <!-- dans le fichier anglais
    nbfrc=$nbfr-2*$m-2*$n-2*$o #calcul du nombre de balises corrigé
    nbenc=$nben-2*$p-2*$q-2*$r #calcul du nombre de balises corrigé
    diff=$nbfrc-$nbenc # calcul de la différence
    if [[ "$nbenc" != "$nbfrc" ]] # si différence avec le corrigé
    then
	echo $k ": différence du nombre de balises (fr-en)= "$diff  >> $CHEMIN_BLFSFR/verif.lst #écriture dans le fichier résultat 'list'
	echo $k >> $CHEMIN_BLFSFR/verif.detail
        bautre=$diff	
	for b in $liste_balise
	do 
		balises $b
#		if [[ $bautre == 0 ]]
#		then
#			break
#		fi
	done	
	if [[ $bautre != 0 ]]
	then
           echo "autres balises :" $bautre >> $CHEMIN_BLFSFR/verif.detail
	fi
     fi
  fi
done
exit 0
