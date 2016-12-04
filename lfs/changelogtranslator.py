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
	#if m and ("fuzzy" in entry.flags or not entry.msgstr):
	if m:
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

regexps.append([re.compile('\[([^\]]+)\] - Updated? to ([^ ]+). +Fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL), '[#1] - Mise à jour vers #2. Corrige #3'])
regexps.append([re.compile('\[([^\]]+)\] - Updated? to ([^ ]+). +Partially fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL), '[#1] - Mise à jour vers #2. Corrige partiellement #3'])
regexps.append([re.compile('\[([^\]]+)\] - Updated? to ([^ ]+) (\([^ ]+\)). +Fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL), '[#1] - Mise à jour vers #2 #3. Corrige #4'])
regexps.append([re.compile('\[([^\]]+)\] - Updated? to ([^ ]+) \(([^ ]+) module\). +Fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL), '[#1] - Mise à jour vers #2 (module #3). Corrige #4'])

regexps.append([re.compile('(20[0-9]{2})-([0-9]{2})-([0-9]{2})'), '#3-#2-#1'])



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

