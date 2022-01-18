#!/bin/bash
cd ~/TheFuckingList

SECONDS=0

#Remove blocklists
rm -rf pihole.txt
rm -rf hosts_nine.txt
rm -rf adguardhome.txt
rm -rf *_tmp.txt

#Collect domain blocklists and clean, piped to reduce writes
wget --quiet --show-progress --output-document=- --input-file=~/TheFuckingList/config/blocklist-links.txt | 
sed '
s/"//g;
s/,//g;
s/[[]//g;
s/[]]//g;
s/0\.0\.0\.0//g;
s/127\.0\.0\.1//g;
s/ //g;
s/:://g;
s/localhost$//g;
s/#.*//g;
s/!.*//g;
/</d;
s/[[:blank:]]//g;
s/[[:space:]]//g;
/^[[:space:]]*$/d;
/^[>=|]/d' | 
sort -f -u > domain_tmp.txt

wget --quiet --show-progress --output-document=- --input-file=~/TheFuckingList/config/blocklist-json.txt | 
sed '
s/"//g;
s/,//g;
s/[[]//g;
s/[]]//g;
s/[[:blank:]]//g;
s/[[:space:]]//g;
/^[[:space:]]*$/d' | 
sort -f -u > domain_extra_tmp.txt

wget --quiet --show-progress --output-document=- --input-file=~/TheFuckingList/config/dead.txt | 
sed '
s/#.*//g;
s/!.*//g;
/</d;
s/[[:blank:]]//g;
s/[[:space:]]//g;
/^[[:space:]]*$/d;
/^[>=|]/d' | 
sort -f -u > domain_exclusions_tmp.txt

#Prepare and group exclusions
cat exclusions.txt | egrep '^\|\|' | cut -d'/' -f1 | cut -d '^' -f1 | cut -d '$' -f1 | tr -d '|' >> domain_exclusions_tmp.txt

#Parcial remove of undead domains
cat ~/temp_undeadomains-{0..100} 2>/dev/null | sort -f -u > undeadlist_tmp.txt
awk '{if (f==1) { r[$0] } else if (! ($0 in r)) { print $0 } } ' f=1 undeadlist_tmp.txt f=2 deadlist.txt > deadlist_tmp.txt

#Remove deadlist from domains and sort
cat deadlist_tmp.txt >> domain_exclusions_tmp.txt
sort -f -u -o domain_exclusions_tmp.txt domain_exclusions_tmp.txt
awk '{if (f==1) { r[$0] } else if (! ($0 in r)) { print $0 } } ' f=1 domain_exclusions_tmp.txt f=2 domain_tmp.txt > pihole.txt

#Add 0.0.0.0 compress into 9 hosts per line
cat pihole.txt | sed 's/^/0.0.0.0 /' | grep "^0" | sed "s/0\.0\.0\.0//g" | tr -d "\n" | egrep -o '\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+' | sed 's/^/0\.0\.0\.0 /g' >> hosts_nine.txt
tail -n 8 pihole.txt | sed 's/^/0.0.0.0 /' >> hosts_nine.txt

#Transform to adblock format, create blocklist, dedupe.
sed --in-place 's/^/||/;s/$/^/' domain_exclusions_tmp.txt
sed --in-place 's/^/||/;s/$/^/' domain_extra_tmp.txt
node --max-old-space-size=15072 --optimize-for-size ~/HostlistCompiler/src/cli.js -c ~/TheFuckingList/config/configuration1.json -o blocklista_tmp.txt
node --max-old-space-size=15072 --optimize-for-size ~/HostlistCompiler/src/cli.js -c ~/TheFuckingList/config/configuration2.json -o blocklistb_tmp.txt
cat blocklista_tmp.txt blocklistb_tmp.txt domain_extra_tmp.txt | awk '!a[$0]++' > blocklist_sorted_tmp.txt
awk '{if (f==1) { r[$0] } else if (! ($0 in r)) { print $0 } } ' f=1 domain_exclusions_tmp.txt f=2 blocklist_sorted_tmp.txt > adguardhome.txt

#Cleanup
find ./ -size +100M -delete
rm -rf *_tmp.txt

#Upload to github
sudo git add -A
sudo git commit -m "daily update"
sudo git push -u origin

#Stats
if (( $SECONDS > 3600 )) ; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo $(date -u)  >> ~/blocklist.log
    echo "$hours hours, $minutes minutes, $seconds seconds elapsed"  >> ~/blocklist.log
elif (( $SECONDS > 60 )) ; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo $(date -u)  >> ~/blocklist.log
    echo "$minutes minutes, $seconds seconds elapsed"  >> ~/blocklist.log
elif (( $SECONDS > 0 )) ; then
    echo $(date -u)  >> ~/blocklist.log
    echo "$SECONDS seconds elapsed"  >> ~/blocklist.log
fi
