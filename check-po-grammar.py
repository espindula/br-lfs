#!/usr/bin/python3
# -*- coding: utf-8 -*-

#    Check PO Grammar v1.0
#    Grammalecte-based automatic spell and grammar checker for po files.
#
#    Copyright 2019 roptat <julien@lepiller.eu>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

import grammalecte
import os.path
import polib
import re
import sys

files = sys.argv
files.pop(0)

gc = grammalecte.GrammarChecker("fr")

gc.gce.setOption("apos", False)
gc.gce.setOption("esp", False)

# Add exceptions when you find some
exceptions = ["LFS", "BLFS", "ALFS", "HLFS", "CLFS", "From", "LFS-Bootscripts", "XSL", "LiveCD",
        "lfs", "blfs", "alfs", "hlfs", "clfs",
        # People names
        "Gerard", "Beekmans", "Dubbs", "Gifford", "Labastie", "Moffat", "Canales", "Esparcia",
        "Lenglet", "Mengual", "Lepiller", "Anderson", "Lizardo", "Reitelbach", "Maisak", "Shevcova",
        "Kveton", "Astle", "Eujon", "Sellers", "Knierim", "Falcon", "Guido", "Bastiaan", "Cranshoff",
        "Scarlet", "Belgium", "Faulborn", "Ralf", "Sprinzl", "Uhlemann", "Fredrik", "Vitaly",
        "Chekasin", "Heil", "Satit", "Phermsawang", "Passet", "Danerklint", "Shizunet", "Co", "Ltd",
        "Init", "World", "Andrade", "Barczak", "Archaic", "Burgess", "Coulson", "Bauscher", 
        "Briggs", "Chilton", "Jeroen", "Coumans", "Groenewoud", "Heerdink", "Huntwork",
        "Kadzban", "Hymers", "Leippe", "McMurchy", "Nicholson", "Patrakov", "Perreault", "Scot",
        "Mc", "Pherson", "Gateway", "Reno", "Schafer", "Tie-Ten-Quee", "Robertson", "Tushar",
        "Teredesai", "Utley", "Winkles",
        # Pseudo
        "bdubbs", "dj", "renodr", "ken", "xry111",
        # Abbreviations
        "NNTP", "ABI", "API", "CRC", "CVS", "EGA", "ELF", "EOF", "EQN", "FHS", "FIFO",
        "FQDN", "GCC", "GID", "IEEE", "IPC", "IRC", "ISP", "LSB", "MBR", "MD5", "NIC", "NLS",
        "NPTL", "Posix", "POSIX", "PCRE", "PID", "PTY", "QOS", "RPC", "RTC", "SBU", "PCH",
        "SCO", "SHA1", "TLDP", "TFTP", "TLS", "UID", "UUID", "VC", "VGA", "VT", "LVM",
        "XFS", "EXT4", "FAT32", "ReiserFS", "NTFS", "ext", "GPT", "JFS", "GUID", "KDE",
        # Variables
        "LC_ALL", "LFS_TGT", "PATH", "TERM", "PS1",
        # Packages
        "Systemd", "Bugzilla", "chroot", "ext2", "ext3", "ext4", "bash", "grub", "Grub", "GRUB",
        "tar", "gawk", "dash", "mawk", "Udev", "Acl", "Attr", "Autoconf", "Automake",
        "Bash", "Bc", "Binutils", "Bzip2", "Check", "Coreutils", "DejaGNU", "Diffutils", "E2fsprogs",
        "Eudev", "Expect", "Findutils", "Flex", "Gawk", "GDBM", "Gettext", "Glibc", "GMP", "Gperf",
        "Grep", "Groff", "Gzip", "Iana-Etc", "Inetutils", "Intltool", "IPRoute2", "Kbd", "Kmod", "Less",
        "Libcap", "Libffi", "Libpipeline", "Libtool", "M4", "Make", "Man-DB", "Meson", "MPFR", "Ncurses",
        "OpenSSL", "Pkg-config", "Procps", "Psmisc", "Readline", "Sed", "Shadow", "Sysklogd", "systemd",
        "Sysvinit", "Tar", "Tcl", "Texinfo", "Time", "Udev-lfs", "Util-linux", "Xz", "Zlib", "Elfutils",
        "Utils", "glibc", "Eudev-manpages", "meson", "Glob", "Gcc", "ASAN", "i386", "LTO", "umask", "gettext",
        "util-linux", "Xz-Utils", "make", "Makefile", "sysroot", "expect",
        # Other terms
        "root", "ROOT", "null", "Core2Duo", "tools", "devpts"]

# Transformations to apply to the text (ignore commands, filenames, ...)
regexps = []
regexps.append([re.compile(r"<computeroutput>.*</computeroutput>", re.IGNORECASE|re.MULTILINE|re.DOTALL), ""])
regexps.append([re.compile(r"<application>.*</application>", re.IGNORECASE|re.MULTILINE|re.DOTALL), ""])
regexps.append([re.compile(r"<userinput>.*</userinput>", re.IGNORECASE|re.MULTILINE|re.DOTALL), ""])
regexps.append([re.compile(r'<userinput remap="[^"]*">.*</userinput>', re.IGNORECASE|re.MULTILINE|re.DOTALL), ""])
regexps.append([re.compile(r"<literal>.*</literal>", re.IGNORECASE|re.MULTILINE|re.DOTALL), ""])
regexps.append([re.compile(r"<foreignphrase>[^<]*</foreignphrase>", re.IGNORECASE|re.MULTILINE|re.DOTALL), ""])
regexps.append([re.compile(r"^[^<]*</userinput>", re.IGNORECASE|re.MULTILINE|re.DOTALL), ""])
regexps.append([re.compile(r"^[^<]*</literal>", re.IGNORECASE|re.MULTILINE|re.DOTALL), ""])
regexps.append([re.compile(r"<userinput>[^<]*$", re.IGNORECASE|re.MULTILINE|re.DOTALL), ""])
regexps.append([re.compile(r"<literal>[^<]*$", re.IGNORECASE|re.MULTILINE|re.DOTALL), ""])
regexps.append([re.compile(r"<command>.*</command>", re.IGNORECASE|re.MULTILINE|re.DOTALL), "quelque chose"])
regexps.append([re.compile(r'<emphasis role="[^"]*">(.*)</emphasis>', re.IGNORECASE|re.MULTILINE|re.DOTALL), "\\1"])
regexps.append([re.compile(r"<emphasis>(.*)</emphasis>", re.IGNORECASE|re.MULTILINE|re.DOTALL), "\\1"])
regexps.append([re.compile(r"<quote>(.*)</quote>", re.IGNORECASE|re.MULTILINE|re.DOTALL), "« \\1 »"])
regexps.append([re.compile(r"<placeholder type=\"[^\"]*\" id=\"[^\"]*\"/>", re.IGNORECASE|re.MULTILINE|re.DOTALL), "quelque chose"])
regexps.append([re.compile(r"<replaceable>.*</replaceable>", re.IGNORECASE|re.MULTILINE|re.DOTALL), "quelque chose"])
regexps.append([re.compile(r"<placeholder type=\"screen\" id=\"0\"/>", re.IGNORECASE|re.MULTILINE|re.DOTALL), "un long exemple"])
regexps.append([re.compile(r"<xref linkend='[^']*'/>", re.IGNORECASE|re.MULTILINE|re.DOTALL), "quelque chose"])
regexps.append([re.compile(r'<xref linkend="[^"]*"/>', re.IGNORECASE|re.MULTILINE|re.DOTALL), "quelque chose"])
regexps.append([re.compile(r'<xref linkend="[^"]*" role="[^"]*"/>', re.IGNORECASE|re.MULTILINE|re.DOTALL), "quelque chose"])
regexps.append([re.compile(r'<ulink url="[^"]*"/>', re.IGNORECASE|re.MULTILINE|re.DOTALL), "quelque chose"])
regexps.append([re.compile(r'<ulink url="[^"]*">([^<]*)</ulink>', re.IGNORECASE|re.MULTILINE|re.DOTALL), "\\1"])
regexps.append([re.compile(r'<systemitem class="filesystem">([^<]*)</systemitem>', re.IGNORECASE|re.MULTILINE|re.DOTALL), "\\1"])
regexps.append([re.compile(r'<systemitem class="username">([^<]*)</systemitem>', re.IGNORECASE|re.MULTILINE|re.DOTALL), "\\1"])
regexps.append([re.compile(r'<systemitem class="groupname">([^<]*)</systemitem>', re.IGNORECASE|re.MULTILINE|re.DOTALL), "\\1"])
regexps.append([re.compile(r'<filename>[^<]*</filename>', re.IGNORECASE|re.MULTILINE|re.DOTALL), "un fichier"])
regexps.append([re.compile(r'<filename class="symlink">[^<]*</filename>', re.IGNORECASE|re.MULTILINE|re.DOTALL), "un lien symbolique"])
regexps.append([re.compile(r'<filename class="[^"]*">[^<]*</filename>', re.IGNORECASE|re.MULTILINE|re.DOTALL), "un fichier"])
regexps.append([re.compile(r"&nbsp;", re.IGNORECASE|re.MULTILINE|re.DOTALL), " "])
regexps.append([re.compile(r"&ndash;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "—"])
regexps.append([re.compile(r"&mdash;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "–"])
regexps.append([re.compile(r"&min-kernel;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "3"])
regexps.append([re.compile(r"&buildtime;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "57"])
regexps.append([re.compile(r"&diskspace;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "35"])
regexps.append([re.compile(r"&version;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "25"])
regexps.append([re.compile(r"&versiond;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "25"])
regexps.append([re.compile(r"&[^;]*-size;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "66"])
regexps.append([re.compile(r"&[^;]*-version;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "25"])
regexps.append([re.compile(r"&[^;]*-patch;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "correctif"])
regexps.append([re.compile(r"[^ ]*\.patch", re.IGNORECASE|re.MULTILINE|re.DOTALL), "correctif"])
regexps.append([re.compile(r"[^ ]*\.[a-z0-9]{1,3}", re.IGNORECASE|re.MULTILINE|re.DOTALL), "un fichier"])

# Checking only systemd?
regexps.append([re.compile(r"<phrase revision=\"sysv\">[^<]*(|<[^/](|/[^p](|p[^h](|h[^r](|r[^a])))))*</phrase>", re.IGNORECASE|re.MULTILINE|re.DOTALL), ""])
regexps.append([re.compile(r"<phrase revision=\"systemd\">(.*)</phrase>", re.IGNORECASE|re.MULTILINE|re.DOTALL), "\\1"])

# Finally some entities that were not removed
regexps.append([re.compile(r"&lt;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "<"])
regexps.append([re.compile(r"&gt;", re.IGNORECASE|re.MULTILINE|re.DOTALL), ">"])
regexps.append([re.compile(r"&eacute;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "é"])
regexps.append([re.compile(r"&egrave;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "è"])
regexps.append([re.compile(r"&ocirc;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "ô"])
regexps.append([re.compile(r"&oelig;", re.IGNORECASE|re.MULTILINE|re.DOTALL), "œ"])



filters = []
filters.append(re.compile(r"^[^ ]*$", re.IGNORECASE))
filters.append(re.compile(r"^&buildtime;$", re.IGNORECASE))
filters.append(re.compile(r"^&diskspace;$", re.IGNORECASE))
filters.append(re.compile(r'^<filename class="[^"]">[^<]*</filename>$', re.IGNORECASE))
filters.append(re.compile(r'^<parameter>[^<]*</parameter>$', re.IGNORECASE))

def filterhtml(msg):
    for regex in regexps:
        msg = regex[0].sub(regex[1], msg)
    return msg

def checkEntry(msg, n):
    for f in filters:
        if f.match(msg):
            return n
 
    text = filterhtml(msg)
    spell_err = gc.oSpellChecker.parseParagraph(text, True)
    actual_errors = 0
    if (not spell_err is None) and (len(spell_err) > 0):
        txt = text
        spell_err.reverse()
        for i in spell_err:
            error = txt[i['nStart']:i['nEnd']].strip()
            if not error in exceptions:
                actual_errors = actual_errors + 1
                txt = txt[:i['nStart']] + '\033[31m' + txt[i['nStart']:i['nEnd']] + '\033[0m {}'.format(i['aSuggestions']) + txt[i['nEnd']:]
        if actual_errors > 0:
            n = n + actual_errors
            print("Dans {} : « {} »".format(filename, txt))
    gramm_err = gc.gce.parse(text, "FR", bDebug=False)
    for i in gramm_err:
        n = n + 1
        print("Dans {} : phrase « {} » : problème possible : {} ".format(filename, text, i['sMessage']))
        print("")
 
    return n

n = 0

for filename in files:
    po = polib.pofile(filename)
    for entry in po:
        if entry.obsolete == 0:
            n = checkEntry(entry.msgstr, n)

print("Resultat : {} problèmes détectés".format(n))
