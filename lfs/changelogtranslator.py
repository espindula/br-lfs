#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
import re
from templatetranslator import TemplateTranslator

languages = sys.argv
languages.pop(0)
files=['chapter01/changelog.po']

tt = TemplateTranslator(files)

tt.append(re.compile('\[([^\]]+)\] - Updated? to ([^ ]+). +Fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL),
	{'fr': '[#1] - Mise à jour vers #2. Corrige #3'})
tt.append(re.compile('\[([^\]]+)\] - Updated? to ([^ ]+). +Partially fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL),
	{'fr': '[#1] - Mise à jour vers #2. Corrige partiellement #3'})
tt.append(re.compile('\[([^\]]+)\] - Updated? to ([^ ]+) (\([^ ]+\)). +Fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL),
	{'fr': '[#1] - Mise à jour vers #2 #3. Corrige #4'})
tt.append(re.compile('\[([^\]]+)\] - Updated? to ([^ ]+) \(([^ ]+) module\). +Fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL),
	{'fr': '[#1] - Mise à jour vers #2 (module #3). Corrige #4'})
tt.append(re.compile('(20[0-9]{2})-([0-9]{2})-([0-9]{2})'),
	{'fr': '#3-#2-#1'})

tt.translate(languages)
