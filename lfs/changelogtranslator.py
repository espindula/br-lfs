#!/usr/bin/python3
# -*- coding: utf-8 -*-

#    Changelog Translator v0.1
#    Traduit automatiquement certaines chaine de carractères de changelog.po

#    Publié par roptat <julien@lepiller.eu> et amj <amj@linuxfromscratch.org> le 2 octobre 2015
#    sous la licence gnu General Public License version 3 pubilée par la Free Software Foundation.
#    Visitez <http://www.gnu.org/licenses/> pour obtenir la licence.



import re
import polib

po = polib.pofile('fr/chapter01/changelog.po')

# regexps
simpleDateRe = re.compile('(20[0-9]{2})-([0-9]{2})-([0-9]{2})')
simpleUpdateRe = re.compile('\[([^\]]*)\] - Update(d?) to ([^ ]*)\.')
fixRe = re.compile('Fixes (.*).')

for entry in po:
    m = simpleDateRe.match(entry.msgid)
    if m:
        entry.msgstr = m.group(3) + '-' + m.group(2) + '-' + m.group(1)
        
        if "fuzzy" in entry.flags:
            entry.flags.remove("fuzzy")
        
        print (entry.msgid + ' -> ' + entry.msgstr)
        
    m = simpleUpdateRe.match(entry.msgid)
    #print(entry.msgid)
    
    if m:
        entry.msgstr = '[' + m.group(1) + ']' + u' - Passage à ' + m.group(3)
        
        if "fuzzy" in entry.flags:
            entry.flags.remove("fuzzy")
        
        m = fixRe.search(entry.msgid)
        
        if m:
            entry.msgstr += ' Corrige ' + m.group(1)
        print ("====>"+entry.msgid + ' -> ' + entry.msgstr)

po.save()
