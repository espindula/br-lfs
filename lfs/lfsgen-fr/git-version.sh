#!/bin/sh

if ! git status > /dev/null; then
	# Either it's not a git repository, or git is unavaliable.
	# Just workaround.
	echo "<!ENTITY version           \"unknown\">"         >  version.ent
	echo "<!ENTITY versiond          \"unknown-systemd\">" >> version.ent
	echo "<!ENTITY releasedate       \"unknown\">"         >> version.ent
	echo "<!ENTITY copyrightdate     \"1999-2021\">"       >> version.ent
	exit 0
fi

export LC_ALL=en_US.utf8
export TZ=US/Pacific

commit_date=$(git show -s --format=format:"%cd" --date=local)

year=$(date --date "$commit_date" "+%Y")
month=$(date --date "$commit_date" "+%B")
month_digit=$(date --date "$commit_date" "+%m")
day=$(date --date "$commit_date" "+%d" | sed 's/^0//')

case $day in
	"1" | "21" | "31" ) suffix="st";;
	"2" | "22" ) suffix="nd";;
	"3" | "23" ) suffix="rd";;
	* ) suffix="th";;
esac

full_date="$month $day$suffix, $year"

sha="$(git describe --abbrev=1)"
if [ "$(git branch --show-current)" = "trunk" ]; then
	sha=$(echo "$sha" | sed 's/-g[^-]*$//')
fi
version="$sha"
versiond="$sha-systemd"

if [ "$(git diff HEAD | wc -l)" != "0" ]; then
	version="$version+"
	versiond="$versiond+"
fi

echo "<!ENTITY version           \"$version\">"            >  version.ent
echo "<!ENTITY versiond          \"$versiond\">"           >> version.ent
echo "<!ENTITY releasedate       \"$full_date\">"          >> version.ent
echo "<!ENTITY copyrightdate     \"1999-$year\">"          >> version.ent
