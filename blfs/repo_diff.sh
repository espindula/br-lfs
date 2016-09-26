for file in `find blfs-en -type d -name stylesheets -prune -o -name '*.xml' -a -type f -print`; do
	new=$(echo $file | sed 's|blfs-en|fr|' | sed 's|xml$|po|')
	[ ! -f $new ] && echo + $new
done


for file in `find fr -type f -a -name '*.po' -print`; do
	old=$(echo $file | sed 's|fr|blfs-en|' | sed 's|po$|xml|')
	[ ! -f $old ] && echo - $old
done


for file in `find fr -type f -a -name '*.po' -print`; do
	if [ $(find fr -type f -a -name $(basename $file) | wc -l) -gt 1 ]; then
		en=$(echo $file | sed 's|fr|blfs-en|' | sed 's|po$|xml|')
		[ ! -f $en ] && echo D $file
	fi
done
