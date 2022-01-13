#!/bin/bash
cd ~/

SECONDS=0
linecount=$(awk 'END{ print NR }' ~/clean_domains.txt)

#Delete done
rm -rf ~/done

#Recover progress if failed to end
cat ~/temp_validomains-{0..100} >> ~/temp_failedtoend.validomains.txt 2>/dev/null
sort -f -u -o ~/temp_failedtoend.validomains.txt ~/temp_failedtoend.validomains.txt
comm -2 -3 ~/clean_domains.txt ~/temp_failedtoend.validomains.txt > ~/temp_clean.domains.txt
sort -f -u -o ~/temp_clean.domains.txt ~/temp_clean.domains.txt

#Cleanup split
rm -rf ~/clean_domains-*
rm -rf ~/temp_validomains-*

#Split for performance
split -n l/8 -d ~/temp_clean.domains.txt ~/temp_clean.domains-
sleep 10

#Start parse
cat temp_clean.domains-00 | ./parse.sh > temp_validomains-0 &
P0=$!
cat temp_clean.domains-01 | ./parse.sh > temp_validomains-1 &
P1=$!
cat temp_clean.domains-02 | ./parse.sh > temp_validomains-2 &
P2=$!
cat temp_clean.domains-03 | ./parse.sh > temp_validomains-3 &
P3=$!
cat temp_clean.domains-04 | ./parse.sh > temp_validomains-4 &
P4=$!
cat temp_clean.domains-05 | ./parse.sh > temp_validomains-5 &
P5=$!
cat temp_clean.domains-06 | ./parse.sh > temp_validomains-6 &
P6=$!
cat temp_clean.domains-07 | ./parse.sh > temp_validomains-7 &
P7=$!
wait $P0 $P1 $P2 $P3 $P4 $P5 $P6 $P7
sleep 300

#Backup
cat ~/deadlist.txt > ~/deadlist.backup.`date +"%d-%m-%Y"`.txt

#Deadlist
cat ~/temp_validomains-{0..100} > ~/validomains.txt 2>/dev/null
cat ~/temp_failedtoend.validomains.txt >> ~/validomains.txt
sort -f -u -o ~/validomains.txt ~/validomains.txt
comm -2 -3 ~/clean.domains.txt ~/validomains.txt > ~/deadlist.txt
cat ~/deadlist.txt > ~/TheFuckingList/deadlist.txt

#Backup
cat ~/clean_domains.txt > ~/clean_domains.backup.`date +"%d-%m-%Y"`.txt
cat ~/validomains.txt > ~/validomains.backup.`date +"%d-%m-%Y"`.txt

#Cleanup
rm -rf ~/temp*
echo $(date -u)  >> ~/done.parse

#Logs
if (( $SECONDS > 3600 )) ; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo $(date -u)  >> ~/parse.log
    echo "$hours hours, $minutes minutes, $seconds seconds elapsed, $((linecount/SECONDS)) queries per second"  >> ~/parse.log
elif (( $SECONDS > 60 )) ; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo $(date -u)  >> ~/parse.log
    echo "$minutes minutes, $seconds seconds elapsed, $((linecount/SECONDS)) queries per second"  >> ~/parse.log
elif (( $SECONDS > 0 )) ; then
    echo $(date -u)  >> ~/parse.log
    echo "$SECONDS seconds elapsed, $((linecount/SECONDS)) queries per second"  >> ~/parse.log
fi
