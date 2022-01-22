#!/bin/bash
cd ~/

SECONDS=0
linecount=$(awk 'END{ print NR }' ~/deadlist.txt)

#Delete done
rm -rf ~/done.dead

#Recover progress if failed to end
cat ~/temp_undeadomains-{0..100} >> ~/temp_failedtoend.undeadomains.txt 2>/dev/null
sort -f -u -o ~/temp_failedtoend.undeadomains.txt ~/temp_failedtoend.undeadomains.txt
comm -2 -3 ~/deadlist.txt ~/temp_failedtoend.undeadomains.txt > ~/temp_deadlist.txt
sort -f -u -o ~/temp_deadlist.txt ~/temp_deadlist.txt

#Cleanup split
rm -rf ~/deadlist-*
rm -rf ~/temp_undeadomains-*

#Split for performance
split -n l/8 -d ~/temp_deadlist.txt ~/temp_deadlist-
sleep 10

#Start parse
cat temp_deadlist-00 | ./parse.sh > temp_undeadomains-0 &
P0=$!
cat temp_deadlist-01 | ./parse.sh > temp_undeadomains-1 &
P1=$!
cat temp_deadlist-02 | ./parse.sh > temp_undeadomains-2 &
P2=$!
cat temp_deadlist-03 | ./parse.sh > temp_undeadomains-3 &
P3=$!
cat temp_deadlist-04 | ./parse.sh > temp_undeadomains-4 &
P4=$!
cat temp_deadlist-05 | ./parse.sh > temp_undeadomains-5 &
P5=$!
cat temp_deadlist-06 | ./parse.sh > temp_undeadomains-6 &
P6=$!
cat temp_deadlist-07 | ./parse.sh > temp_undeadomains-7 &
P7=$!
wait $P0 $P1 $P2 $P3 $P4 $P5 $P6 $P7
sleep 10

#Backup
cat ~/deadlist.txt > ~/deadlist.backup.`date +"%d-%m-%Y"`.txt

#Deadlist
cat ~/temp_undeadomains-{0..100} > ~/undeadomains.txt 2>/dev/null
cat ~/temp_failedtoend.undeadomains.txt >> ~/undeadomains.txt
sort -f -u -o ~/undeadomains.txt ~/undeadomains.txt
comm -2 -3 ~/temp_deadlist.txt ~/undeadomains.txt > ~/deadlist.txt
cat ~/deadlist.txt > ~/TheFuckingList/deadlist.txt

#Backup
cat ~/undeadomains.txt > ~/undeadomains.backup.`date +"%d-%m-%Y"`.txt

#Cleanup
rm -rf ~/temp*
echo $(date -u)  >> ~/done.dead

#Logs
if (( $SECONDS > 3600 )) ; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo $(date -u)  >> ~/dead.log
    echo "$hours hours, $minutes minutes, $seconds seconds elapsed, $((linecount/SECONDS)) queries per second"  >> ~/dead.log
elif (( $SECONDS > 60 )) ; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo $(date -u)  >> ~/dead.log
    echo "$minutes minutes, $seconds seconds elapsed, $((linecount/SECONDS)) queries per second"  >> ~/dead.log
elif (( $SECONDS > 0 )) ; then
    echo $(date -u)  >> ~/dead.log
    echo "$SECONDS seconds elapsed, $((linecount/SECONDS)) queries per second"  >> ~/dead.log
fi
