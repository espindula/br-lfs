#!/bin/bash
# validation de la concordance du nb de balises entre VF et VO pour BLFS
#
# la liste des diff�rences est dans verif.list
# la liste complete est dans verif.detail
# l'option -q permet de limiter les sorties � l'�cran
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


# on se d�place � la racine de la copie de travail de BLFS-fr
cd $CHEMIN_BLFSFR

# d�claration des variables

declare -i nbfrc # nb de balises corrig� dans les fichiers fran�ais ( on enl�ve le nombre de balise <foreignphrase> )
declare -i nbfr # nb de balises dans les fichiers fran�ais
declare -i nbenc # nb de balises corrig� dans les fichiers fran�ais ( on enl�ve le nombre de balise <foreignphrase> )
declare -i nben # nb de balises dans les fichiers fran�ais
declare -i diff # diff�rence de balises entre le fichier fran�ais et le fichier anglais
declare -i bfr # pour la d�termination des erreurs
declare -i ben # pour la d�termination des erreurs
declare -i bdiff # pour la d�termination des erreurs
declare -i bautre # pour la d�termination des erreurs

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
# diff�rence fr-en
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

#initialisation du fichier r�sultat 'list'
> $CHEMIN_BLFSFR/verif.lst
> $CHEMIN_BLFSFR/verif.detail

#recherche des fichiers xml dans listxml
for i in $(cat $CHEMIN_BLFSFR/listxml)
do
  if [[ $1 != "-q" ]]
  then
    echo $i # affichage du fichier en cours
  fi
  k=$i
  j=$CHEMIN_BLFSFR/"../blfs-en/BOOK/"${i:2} # initialisation du chemin vers le fichier anglais � partir du fichier fran�ais
  i=$CHEMIN_BLFSFR$( echo $i | sed -e "s@^\.*@@g")
  cp $j tempen
  cp $i tempfr
  j=tempen
  i=tempfr
  sed -e "s/<!--/<!--\n/g" -e "s/-->/-->\n/g" -i $i
  sed -e "s/<!--/<!--\n/g" -e "s/-->/-->\n/g" -i $j
  sed -e "/<!--/,/-->/ {
           d
            }" -i $i  
  sed -e "/<!--/,/-->/ {
           d
            }" -i $j
   nbfr=$(cat $i 2>>$CHEMIN_LOG/robot.err | grep -o "<" | wc -l) #d�termination du nombre de balises dans le fichier fran�ais
  if [[ $? -gt 0 ]]
  then
     exit 1
  fi
  nben=$(cat $j 2>>$CHEMIN_LOG/robot.err| grep -o "<" | wc -l)   #d�termination du nombre de balises dans le fichier anglais
    if [[ $? -gt 0 ]]
  then
     exit 1
  fi
  if [[ $nbfr != $nben ]]  #teste si diff�rence 
  then
    m=$(cat $i | grep -o "<foreign" | wc -l)  #d�termination du nombre de balises <foreign dans le fichier fran�ais
    n=$(cat $i | grep -o "<acronym" | wc -l) #d�termination du nombre de balises <acronyme dans le fichier fran�ais
    o=$(cat $i | grep -o "<!--" | wc -l) #d�termination du nombre de balises <!-- dans le fichier fran�ais
    p=$(cat $j | grep -o "<foreign" | wc -l)  #d�termination du nombre de balises <foreign dans le fichier anglais
    q=$(cat $j | grep -o "<acronym" | wc -l) #d�termination du nombre de balises <acronyme dans le fichier anglais
    r=$(cat $j | grep -o "<!--" | wc -l) #d�termination du nombre de balises <!-- dans le fichier anglais
    nbfrc=$nbfr-2*$m-2*$n-2*$o #calcul du nombre de balises corrig�
    nbenc=$nben-2*$p-2*$q-2*$r #calcul du nombre de balises corrig�
    diff=$nbfrc-$nbenc # calcul de la diff�rence
    if [[ "$nbenc" != "$nbfrc" ]] # si diff�rence avec le corrig�
    then
	echo $i ": diff�rence du nombre de balises (fr-en)= "$diff  >> $CHEMIN_BLFSFR/verif.lst #�criture dans le fichier r�sultat 'list'
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
