import sys
import polib

input_filename = sys.argv[1]

po = polib.pofile(input_filename)
changed = False
for entry in po:
    if 'xml-text' not in entry.flags:
        entry.flags.append('xml-text')
        changed = True
    if 'xml-format' in entry.flags:
        entry.flags.remove('xml-format')
        changed = True
if changed:
    po.save()
