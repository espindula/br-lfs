#!/bin/sh
sed -e 's|xreflabel="Foreword|xreflabel="Avant-propos|g' \
    -e 's|xreflabel="Organization|xreflabel="Organisation|g' \
    -e 's|xreflabel="Who Would Want to Read this Book|xreflabel="Qui voudrait lire ce livre|g' \
    -e 's|xreflabel="Preface|xreflabel="Préface|g' \
    -e 's|xreflabel="Errata|&|g' \
    -e 's|xreflabel="Introduction|&|g' \
    -e 's|xreflabel="wiki|&|g' \
    -e 's|xreflabel="Configuring the JAVA environment|xreflabel="Configuration de l'"'"'environnement JAVA|g' \
    -e 's|xreflabel="Running a Subversion Server|xreflabel="Exécuter un serveur subversion|g' \
    -e 's|xreflabel="Perl modules|xreflabel="Modules Perl|g' \
    -e 's|xreflabel="build and installation instructions|xreflabel="Instructions d'"'"'installation des modules Perl|g' \
    -e 's|xreflabel="instructions for packages using Build.PL|xreflabel="Instructions pour les modules Perl qui utilisent Build.PL |g' \
    -e 's|xreflabel="alternate auto installation instructions|xreflabel="Instructions alternatives d'"'"'installation automatique des modules Perl.|g' \
    -e 's|xreflabel="Java Binary|xreflabel="Binaire Java|g' \
    -e 's|xreflabel="Configuring OpenJDK|xreflabel="Configuration de OpenJDK|g' \
    -e 's|xreflabel='"'"'JRE Certificate Authorithy Certificates|xreflabel='"'"'Certificats d\&apos;autorité de certification pour JRE|g' \
    -e 's|xreflabel="Other Programming Tools|xreflabel="Autres outils de programmation|g' \
    -e 's|xreflabel="Python Modules|xreflabel="Modules Python|g' \
    -e 's|xreflabel="General Libraries and Utilities|xreflabel="Bibliothèques et outils généraux|g' \
    -e 's|xreflabel="D-Bus custom services directory|xreflabel="Répertoire des services personnalisés de D-Bus|g' \
    -e 's|xreflabel="Locale Related Issues|xreflabel="Problèmes liés aux locales|g' \
    -e 's|xreflabel="Needed Encoding Not a Valid Option|xreflabel="L'"'"'encodage nécessaire n'"'"'est pas une option valide|g' \
    -e 's|xreflabel="Program Assumes Encoding|xreflabel="Le programme suppose l'"'"'encodage|g' \
    -e 's|xreflabel="Wrong Filename Encoding|xreflabel="Noms de fichiers dans un mauvais encodage|g' \
    -e 's|xreflabel="Breaks Multibyte Characters|xreflabel="Casse les caractères multi-octets|g' \
    -e 's|xreflabel="Incorrect Manual Page Encoding|xreflabel="Pages de manuel dans un mauvais encodage|g' \
    -e 's|xreflabel="Going Beyond BLFS|xreflabel="Aller au-delà de BLFS|g' \
    -e 's|xreflabel="libraries|xreflabel="bibliothèques|g' \
    -e 's|xreflabel="Using Multiple Processors|xreflabel="Utilisation de processeurs multiples|g' \
    -e 's|xreflabel="Automated Building Procedures|xreflabel="Procédures de construction automatique|g' \
    -e 's|xreflabel="Mirrors|xreflabel="Miroirs|g' \
    -e 's|xreflabel="Getting the Source Packages|xreflabel="Obtenir les sources des paquets|g' \
    -e 's|xreflabel="Book Version|xreflabel="Version du livre|g' \
    -e 's|xreflabel="Change Log|xreflabel="Journal des modifications|g' \
    -e 's|xreflabel="Mailing lists|xreflabel="Listes de diffusion|g' \
    -e 's|xreflabel="Which sections of the book\?|xreflabel="Quelles sections du livre m'"'"'intéressent ?|g' \
    -e 's|xreflabel="Credits|xreflabel="Crédits|g' \
    -e 's|xreflabel="Introduction to|xreflabel="Introduction à|g' \
    -e 's|xreflabel="Further KDE4 packages|xreflabel="Paquet Supplémentaires de KDE4|g' \
    -e 's|xreflabel="Starting KDE4|xreflabel="Démarrage de KDE4|g' \
    -e 's|xreflabel="LXQt Pre-Install|xreflabel="pré-installation du bureau LXQt|g' \
    -e 's|xreflabel="LXQt-Post-Install|xreflabel="post-installation du bureau LXQt|g' \
    -e 's|xreflabel="Multimedia|xreflabel="Multimédia|g' \
    -e 's|xreflabel='"'"'NFS Utilities Installation|xreflabel='"'"'Installation de NFS Utilities|g' \
    -e 's|xreflabel="Configuring for Network Filesystems|xreflabel="Configuration des systèmes de fichiers réseau|g' \
    -e 's|xreflabel="Networking|xreflabel="Réseau|g' \
    -e 's|xreflabel="Firewalling|xreflabel="Pare-feu|g' \
    -e 's|xreflabel="Firewalling Introduction|xreflabel="Introduction au pare-feu|g' \
    -e 's|xreflabel="writing the firewalling-setup-scripts|xreflabel="écriture des scripts d'"'"'initialisation du pare-feu|g' \
    -e 's|xreflabel="Personal Firewall|xreflabel="Pare-feu personnel|g' \
    -e 's|xreflabel="Masquerading Router|xreflabel="Routeur Masquant|g' \
    -e 's|xreflabel="BusyBox example number 4|xreflabel="Exemple de BusyBox numéro 4|g' \
    -e 's|xreflabel="Conclusion|&|g' \
    -e 's|xreflabel="Extra Information|xreflabel="Informations supplémentaires|g' \
    -e 's|xreflabel="links for further reading|xreflabel="liens de  lectures complémentaires|g' \
    -e 's|xreflabel="Certificate Authority Certificates|xreflabel="Certificats d'"'"'autorité de certification|g' \
    -e 's|xreflabel="vulnerabilities|xreflabel="vulnérabilités|g' \
    -e 's|xreflabel="The Bash Shell Startup Files|xreflabel="Les fichiers de démarrage du shell Bash|g' \
    -e 's|xreflabel="Creating a Custom Boot Device|xreflabel="Créer un périphérique de démarrage personnalisé|g' \
    -e 's|xreflabel="About Firmware|xreflabel="À propos des Firmwares|g' \
    -e 's|xreflabel="About System Users and Groups|xreflabel="À propos des utilisateurs et des groupes systèmes|g' \
    -e 's|xreflabel="Configuring for Adding Users|xreflabel="Configuration de l'"'"'ajout d'"'"'utilisateurs|g' \
    -e 's|xreflabel="The vimrc Files|xreflabel="Les fichiers vimrc|g' \
    -e 's|xreflabel="Random number generation|xreflabel="Génération de nombres aléatoires|g' \
    -e 's|xreflabel="After LFS Configuration Issues|xreflabel="Questions de configuration après LFS|g' \
    -e 's|xreflabel="About Devices|xreflabel="À propos des périphériques|g' \
    -e 's|xreflabel="Customizing your Logon with /etc/issue|xreflabel="Personnaliser votre écran de connexion avec /etc/issue|g' \
    -e 's|xreflabel="Post LFS Configuration and Extra Software|xreflabel="Configuration Post LFS et logiciels supplémentaires|g' \
    -e 's|xreflabel="Printing, Scanning and Typesetting|xreflabel="Impression, Scan et Composition|g' \
    -e 's|xreflabel="Setting the PATH for TeX Live|xreflabel="Initialisation du PATH pour TeX Live|g' \
    -e 's|xreflabel="MTA|&|g' \
    -e 's|xreflabel="Servers|xreflabel="Serveurs|g' \
    -e 's|xreflabel="Xorg Fonts|xreflabel="Polices Xorg|g' \
    -e 's|xreflabel="Xorg build environment|xreflabel="Environnement de construction de Xorg|g' \
    -e 's|xreflabel="Xorg Libraries|xreflabel="Bibliothèques Xorg|g' \
    -e 's|xreflabel="Xorg Protocol Headers|xreflabel="Protocoles Xorg|g' \
    -e 's|xreflabel="X Window System|xreflabel="Système X Window|g' \
    -e 's|xreflabel="Xorg Applications|xreflabel="Applications Xorg|g' \
    -e 's|xreflabel="Xorg Drivers|xreflabel="Pilotes Xorg|g' \
    -e 's|xreflabel="Testing Xorg|xreflabel="Test de Xorg|g' \
    -e 's|xreflabel="Checking the DRI installation|xreflabel="Vérifier l'"'"'installation de la Direct Rendering Infrastructure|g' \
    -e 's|xreflabel="Hybrid Graphics|xreflabel="Hybrid Graphics|g' \
    -e 's|xreflabel="Xft Font Protocol|xreflabel="Protocole Xft Font|g' \
    -e 's|xreflabel="X plus Window and Display Managers|xreflabel="X et gestionnaires de fenêtres et d'"'"'affichage|g' \
    -e 's|xreflabel="Other Window Managers|xreflabel="Autres gestionnaires de fenêtre|g' \
    -e 's|xreflabel="X Software|xreflabel="Logiciels X|g' \
    -e 's|<book>|<book lang="fr">|g' \
    -i $1
