#!/bin/bash
cd ~/TheFuckingList

SECONDS=0

#Remove blocklists
rm -rf pihole.txt
rm -rf hosts_nine.txt
rm -rf adguardhome.txt
rm -rf *_tmp.txt

#Collect domain blocklists
wget --quiet --show-progress --output-document=- --input-file=~/TheFuckingList/config/blocklist-links.txt > domain_tmp.txt
wget --quiet --show-progress --output-document=- --input-file=~/TheFuckingList/config/dead.txt > domain_exclusions_tmp.txt
wget --quiet --show-progress --output-document=- --input-file=~/TheFuckingList/config/blocklist-json.txt > domain_extra_tmp.txt

#RAW DOMAINS remove comments, null ips, blank space, etc. sort
sed --in-place 's/"//g;s/,//g;s/[[]//g;s/[]]//g;s/[[:blank:]]//g;s/[[:space:]]//g;/^[[:space:]]*$/d' domain_extra_tmp.txt
cat domain_extra_tmp.txt >> domain_tmp.txt
sed --in-place 's/0\.0\.0\.0//g;s/127\.0\.0\.1//g;s/ //g;s/:://g;s/localhost$//g;s/#.*//g;s/!.*//g;/</d;s/[[:blank:]]//g;s/[[:space:]]//g;/^[[:space:]]*$/d;/^[>=|]/d' domain_tmp.txt
sort -f -u -o domain_tmp.txt domain_tmp.txt

#EXCLUSIONS prepare and group exclusions
cat exclusions.txt | egrep '^\|\|' | cut -d '/' -f1 | cut -d '^' -f1 | cut -d '$' -f1 | tr -d '|' >> domain_exclusions_tmp.txt
sed --in-place 's/#.*//g;s/!.*//g;/</d;s/[[:blank:]]//g;s/[[:space:]]//g;/^[[:space:]]*$/d;/^[>=|]/d' domain_exclusions_tmp.txt

#DEADLIST parcial remove of undead domains
cat ~/temp_undeadomains-{0..100} > ~/TheFuckingList/undeadlist_tmp.txt 2>/dev/null
sort -f -u -o undeadlist_tmp.txt undeadlist_tmp.txt
comm -2 -3  deadlist.txt undeadlist_tmp.txt > deadlist_tmp.txt
cat deadlist_tmp.txt > deadlist.txt
cat deadlist.txt >> domain_exclusions_tmp.txt

#PIHOLE sort domain_exclusions_tmp and prune domain_tmp into pihole
sort -f -u -o domain_exclusions_tmp.txt domain_exclusions_tmp.txt
comm -2 -3 domain_tmp.txt domain_exclusions_tmp.txt > pihole.txt

#HOSTS add 0.0.0.0 compress into 9 hosts per line
sed 's/^/0.0.0.0 /' pihole.txt > hosts_tmp.txt
cat hosts_tmp.txt | grep "^0" | sed "s/0\.0\.0\.0//g" | tr -d "\n" | egrep -o '\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+' | sed 's/^/0\.0\.0\.0 /g' >> hosts_nine.txt

#ADGUARD transform domain_exclusions_tmp to adblock format, create blocklist, dedupe.
sed --in-place 's/^/||/;s/$/^/' domain_exclusions_tmp.txt
sed --in-place 's/^/||/;s/$/^/' domain_extra_tmp.txt
node --max-old-space-size=15072 --optimize-for-size ~/HostlistCompiler/src/cli.js -c ~/TheFuckingList/config/configuration1.json -o blocklista_tmp.txt
node --max-old-space-size=15072 --optimize-for-size ~/HostlistCompiler/src/cli.js -c ~/TheFuckingList/config/configuration2.json -o blocklistb_tmp.txt
cat blocklista_tmp.txt blocklistb_tmp.txt > blocklist_not_sorted_tmp.txt
cat domain_extra_tmp.txt >> blocklist_not_sorted_tmp.txt
awk '!a[$0]++' blocklist_not_sorted_tmp.txt > blocklist_sorted_tmp.txt
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
