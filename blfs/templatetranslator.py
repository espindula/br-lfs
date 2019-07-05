#!/usr/bin/python3
# -*- coding: utf-8 -*-

#    Template Translator v0.1
#    Traduit automatiquement certaines chaine de caractères des paquets

#    Publié par roptat <julien@lepiller.eu> le 8 août 2016
#    sous la licence gnu General Public License version 3 pubilée par la Free Software Foundation.
#    Visitez <http://www.gnu.org/licenses/> pour obtenir la licence.


import sys
import re
import polib

files = sys.argv
files.pop(0)

def convert(entry, regexp, template):
	m = regexp.match(entry.msgid)
	# do not modify anything if the translation is already correct
	if m and ("fuzzy" in entry.flags or not entry.msgstr):
		msgstr = template
		try:
			msgstr = msgstr.replace("#1", m.group(1))
			msgstr = msgstr.replace('#2', m.group(2))
			msgstr = msgstr.replace('#3', m.group(3))
			msgstr = msgstr.replace('#4', m.group(4))
		except:
			x=1
		entry.msgstr = msgstr
		if "fuzzy" in entry.flags:
			entry.flags.remove("fuzzy")


# regexps
regexps = []

# find an MD5 sum
regexps.append([re.compile('([a-f0-9]{32})$'), '#1'])
# convert KB to Ko, MB to Mo and GB to Go, and keep SBU
regexps.append([re.compile('([0-9\\.]+) ([KMG])B$'), '#1 #2o'])
regexps.append([re.compile('([0-9\\.]+) ([KMG])B \(with tests\)$'), '#1 #2o (avec les tests)'])
regexps.append([re.compile('([0-9\\.]+) ([KMG])B \(additional ([0-9\\.]+) ([KMG])B for the tests\)$'), '#1 #2o (#3 #4o supplémentaires pour les tests)'])
regexps.append([re.compile('([0-9\\.]+) ([KMG])B \(add ([0-9\\.]+) ([KMG])B for tests\)$'), '#1 #2o (plus #3 #4o pour les tests)'])
regexps.append([re.compile('([0-9\\.]+) SBU$'), '#1 SBU'])
regexps.append([re.compile('([0-9\\.]+) SBU \(with tests\)$'), '#1 SBU (avec les tests)'])
regexps.append([re.compile('([0-9\\.]+) SBU \(using parallelism=([0-9]+)\)$'), '#1 SBU (avec parallélisme = #2)'])
regexps.append([re.compile('([0-9\\.]+) SBU \(using parallelism=([0-9]+); with tests\)$'), '#1 SBU (avec parallélisme = #2&nbsp;; avec les tests)'])
regexps.append([re.compile('([0-9\\.]+) SBU \(additional ([0-9\\.]+) SBU for the tests\)$'), '#1 SBuo (#2 SBU supplémentaires pour les tests)'])
regexps.append([re.compile('([0-9\\.]+) SBU \(add ([0-9\\.]+) SBU for tests\)$'), '#1 SBU (plus #2 SBU pour les tests)'])
regexps.append([re.compile('less than 0.1 SBU$'), 'moins de 0.1 SBU'])
# termes à gauche des informations
regexps.append([re.compile('Package Information$'), 'Informations sur le paquet'])
regexps.append([re.compile('Download \(HTTP\): (.*)$'), 'Téléchargement (HTTP)&nbsp;: #1'])
regexps.append([re.compile('Download \(FTP\): (.*)$'), 'Téléchargement (FTP)&nbsp;: #1'])
regexps.append([re.compile('Download MD5 sum: (.*)$'), 'Somme de contrôle MD5 du téléchargement&nbsp;: #1'])
regexps.append([re.compile('Download size: (.*)$'), 'Taille du téléchargement&nbsp;: #1'])
regexps.append([re.compile('Estimated disk space required: (.*)$'), 'Estimation de l\'espace disque requis&nbsp;: #1'])
regexps.append([re.compile('Estimated build time: (.*)$'), 'Estimation du temps de construction&nbsp;: #1'])
regexps.append([re.compile('(http://[^ ]*)$'), '#1'])
regexps.append([re.compile('(https://[^ ]*)$'), '#1'])
regexps.append([re.compile('(ftp://[^ ]*)$'), '#1'])
# Dépendances
regexps.append([re.compile('Optional Runtime Dependencies$'), 'Dépendances à l\'exécution facultatives'])
regexps.append([re.compile('(.*) Dependencies$'), 'Dépendances de #1'])
regexps.append([re.compile('Required$'), 'Requises'])
regexps.append([re.compile('Optional$'), 'Facultatives'])
regexps.append([re.compile('Optional \(Required if building GNOME\)$'), 'Facultatives (requises pour construire GNOME)'])
regexps.append([re.compile('Recommended$'), 'Recommandées'])
regexps.append([re.compile('Recommended \(Required if building GNOME\)$'), 'Recommandées (requises pour construire GNOME)'])
regexps.append([re.compile('Recommended \(required for the testsuite\)$'), 'Recommandées (requises pour la suite de tests)'])
regexps.append([re.compile('User Notes: (.*)$'), 'Notes utilisateur&nbsp;: #1'])
# Titres
regexps.append([re.compile('Installation of (.*)$'), 'Installation de #1'])
regexps.append([re.compile('Command Explanations$'), 'Explication des commandes'])
regexps.append([re.compile('Config files$'), 'Fichiers de configuration'])
regexps.append([re.compile('Config file$'), 'Fichier de configuration'])
regexps.append([re.compile('Config Files$'), 'Fichiers de configuration'])
regexps.append([re.compile('Config File$'), 'Fichier de configuration'])
regexps.append([re.compile('Configuring ([^ ]+)$'), 'Configuration de #1'])
regexps.append([re.compile('Kernel Configuration$'), 'Configuration du noyau'])
regexps.append([re.compile('Enable the following options in the kernel configuration and recompile the kernel if necessary:$'), 'Activez les options suivantes dans la configuration du noyau et recompilez le noyau si nécessaire&nbsp;:'])
regexps.append([re.compile('Boot Script$'), 'Script de démarrage'])
regexps.append([re.compile('Boot Scripts$'), 'Scripts de démarrage'])
regexps.append([re.compile('Systemd Unit(s?)$'), 'Unité#1 systemd'])
regexps.append([re.compile('<phrase revision="sysv">Boot Script</phrase> <phrase revision="systemd">Systemd Unit</phrase>$'), '<phrase revision="sysv">Script de démarrage</phrase> <phrase revision="systemd">Unité Systemd</phrase>'])
regexps.append([re.compile('Configuration Information$'), 'Informations sur la configuration'])
regexps.append([re.compile('Installed Program$'), 'Programme installé'])
regexps.append([re.compile('Installed Programs$'), 'Programmes installés'])
regexps.append([re.compile('Installed Library$'), 'Bibliothèque installée'])
regexps.append([re.compile('Installed Libraries$'), 'Bibliothèques installées'])
regexps.append([re.compile('Installed Directory$'), 'Répertoire installé'])
regexps.append([re.compile('Installed Directories$'), 'Répertoires installés'])
regexps.append([re.compile('Short Descriptions$'), 'Descriptions courtes'])
# phrases récurrentes
regexps.append([re.compile('Install ([^ ]*) by running the following commands:$'), 'Installez #1 en lançant les commandes suivantes&nbsp;:'])
regexps.append([re.compile('(<userinput.*>.*</userinput>)$', re.MULTILINE|re.DOTALL), '#1'])
regexps.append([re.compile('(<literal>.*</literal>)$', re.MULTILINE|re.DOTALL), '#1'])
regexps.append([re.compile('(<computeroutput>.*</computeroutput>)$', re.MULTILINE|re.DOTALL), '#1'])
regexps.append([re.compile('Now, as the (.*) user:$'), 'Maintenant, en tant qu\'utilisateur #1&nbsp;:'])
regexps.append([re.compile('To test the results, issue:? (<command>.*</command>).$'), 'Pour tester les résultats lancez&nbsp;: #1.'])
regexps.append([re.compile('To run the test suite, issue:? (<command>.*</command>).$'), 'Pour lancer la suite de tests, tapez&nbsp;: #1.'])
regexps.append([re.compile('This package does not come with a test suite.$'), 'Ce paquet n\'est pas fourni avec une suite de tests.'])
regexps.append([re.compile('Additional Downloads$'), 'Téléchargements supplémentaires'])
regexps.append([re.compile('Required [pP]atch: (.*)$'), 'Correctif requis&nbsp;: #1'])
regexps.append([re.compile('(<othername>.*)$'), '#1'])
regexps.append([re.compile('Introduction to (.*)$'), 'Introduction à #1'])
regexps.append([re.compile('(<xref [^>]*>)$'), '#1'])
regexps.append([re.compile('To start the (<command>.*</command>) daemon at boot, enable the previously installed systemd unit by running the following command as the (<systemitem class="username">root</systemitem>) user:$'), 'Pour démarrer le démon #1 au démarrage, activez l\'unité systemd précédemment installée en lançant la commande suivante en tant qu\'utilisateur #2&nbsp;:'])
regexps.append([re.compile('(<command>[^ <]*</command>)$'), '#1'])
regexps.append([re.compile('(<filename[^>]*>[^ <]*</filename>)$'), '#1'])
regexps.append([re.compile('(<command>.*</command>): This sed silences several useless and annoying warnings (generated )?(from|by) libtool.$'), '#1&nbsp;: Ce sed rend muets de nombreux avertissements inutiles et ennuyeux de libtool.'])
regexps.append([re.compile('(<command>.*</command>): This sed silences several useless and obsolete warnings (generated )?(from|by) libtool.$'), '#1&nbsp;: Ce sed rend muets de nombreux avertissements inutiles et obsolètes de libtool.'])
regexps.append([re.compile('([^ <]*)$'), '#1'])
regexps.append([re.compile('You can start (<application>.*</application>) from a TTY using (<xref linkend="xinit"/>).$'), 'Vous pouvez démarrer #1 depuis un TTY avec #2.'])
regexps.append([re.compile('(<.*>): Use this to disable (.*) support.?$'), '#1&nbsp;: Utilisez ce paramètre pour désactiver le support de #2'])
regexps.append([re.compile('(<.*>): Use this switch if you don\'t have (<application>.*</application>) installed.?$'), '#1&nbsp;: Utilisez ce paramètre si vous n\'avez pas installé #2'])
regexps.append([re.compile('(<.*>): Use these switches if you don\'t have (<application>.*</application>) installed.?$'), '#1&nbsp;: Utilisez ces paramètres si vous n\'avez pas installé #2'])
regexps.append([re.compile('(<.*>): Use this switch if you did( no)?(n\')?t install (<application>.*</application>).?$'), '#1&nbsp;: Utilisez ce paramètre si vous n\'avez pas installé #3'])
regexps.append([re.compile('(<.*>): Use these switches if you did not install (<application>.*</application>).?$'), '#1&nbsp;: Utilisez ces paramètres si vous n\'avez pas installé #2'])
regexps.append([re.compile('several in (&kde-dir;/[^ ]*)$'), 'plusieurs dans #1'])
regexps.append([re.compile('This package does not come with a working test suite.?$'), 'Ce paquet ne contient pas de suite de tests utilisable.'])
regexps.append([re.compile('contains the (<application>.*</application>) API functions.$'), 'Contient les fonctions de l\'API de #1'])
regexps.append([re.compile('Now as the <systemitem class="username">root</systemitem> user:'), 'Maintenant en tant qu\'utilisateur <systemitem class="username">root</systemitem>&nbsp;:'])
regexps.append([re.compile('Project Home Page: (<ulink .*/>)$', re.MULTILINE|re.DOTALL), 'Page d\'accueil du projet&nbsp;: #1'])
regexps.append([re.compile('Download Location: (<ulink .*/>)$', re.MULTILINE|re.DOTALL), 'Emplacement du téléchargement&nbsp;: #1'])
regexps.append([re.compile('(<.*>): This switch is used to apply( a)? higher level of( the)? compiler( the)? optimizations?.?$', re.MULTILINE|re.DOTALL), '#1&nbsp;: Ce paramètre est utilisé pour appliquer un plus haut niveau d\'optimisation du compilateur.'])
regexps.append([re.compile('(<ulink [^>]*/>)$', re.MULTILINE|re.DOTALL), '#1'])
regexps.append([re.compile('(<ulink [^>]*/>, )+, and (<ulink [^>]*/>)$', re.MULTILINE|re.DOTALL), '#1 et #2'])
regexps.append([re.compile('Fix a build issue with ([^ ]+)$', re.MULTILINE|re.DOTALL), 'Corrigez un problème de construction avec #1.'])


#regexps.append([re.compile('$'), ''])

number = len(files)
current = 1

for filename in files:
	print('Traitement du fichier ', current, '/', number, '     \r',
			end="", flush=True),
	current = current + 1
	po = polib.pofile(filename)
	for entry in po:
		for reg in regexps:
			convert(entry, reg[0], reg[1])
	po.save()
print('')

