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
		entry.flags.remove("fuzzy")


frenchMonth = {
	'January': 'Janvier',
	'February': 'Février',
	'March': 'Mars',
	'April': 'Avril',
	'May': 'Mai',
	'June': 'Juin',
	'July': 'Juillet',
	'August': 'Août',
	'September': 'Septembre',
	'October': 'Octobre',
	'November': 'Novembre',
	'December': 'Décembre'
}

# regexps
regexps = []

regexps.append([re.compile('\[([^\]]+)\] - Updated? to ([^ ]+). +Fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL), '[#1] - Mise à jour vers #2. Corrige #3'])
regexps.append([re.compile('\[([^\]]+)\] - Updated? to ([^ ]+) (\([^ ]+\)). +Fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL), '[#1] - Mise à jour vers #2 #3. Corrige #4'])
regexps.append([re.compile('\[([^\]]+)\] - Updated? to ([^ ]+) \(([^ ]+) module\). +Fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL), '[#1] - Mise à jour vers #2 (module #3). Corrige #4'])

datereg = re.compile('([^ ]+) ([0-9]{1,2})(th|nd|st|rd), (20[0-9]{2})')



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
		m = datereg.match(entry.msgid)
		if m and ("fuzzy" in entry.flags or not entry.msgstr):
			day = m.group(2)
			if int(day) == 1:
				day = '1er'
			month = frenchMonth[m.group(1)]
			year = m.group(4)
			entry.msgstr = day + " " + month + " " + year
			entry.flags.remove("fuzzy")
	po.save()
print('')

