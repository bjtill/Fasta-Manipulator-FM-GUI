#!/bin/bash
#May 31, 2024
#GUI interface Fasta Manipulator
wget https://ucdavis.box.com/shared/static/an5oulrxi61tkmos5vmj08qmmfxi0m8p.jpeg
mv an5oulrxi61tkmos5vmj08qmmfxi0m8p.jpeg logo.jpeg
YADINPUT=$(yad --width=1000 --title="Fasta Manipulator (FM)" --image=logo.jpeg --text="Version 1.0

ABOUT: A GUI interface for manipulation of fasta files.  

USAGE: There are several different features this tool provides:
1) Remove any entries with an N (hard masked). 2) Conversion of a standard fasta formatted file to a two column format. 3) Conversion of fasta sequences to have a user-selected number of bases per line. 4) Random subsetting of a multi-entry fasta. 5) Subsetting a multi-entry fasta based on fasta header information. 

OUTPUTS: 
1) A new file is created for options 2-5. For example if you choose a two column conversion and a random subset, a file of the complete fasta file converted to two columns will be produced and a file in original fasta format with a random selection of user-defined n entries will be produced. If you want this random set to be converted to two columns, you need to run this program a second time. Note that if removal of Ns is selected, this action is applied to all output files.

See URL for more details. 

LICENSE: MIT License. Copyright (c) 2024 Bradley John Till. Full details found at URL

DEPENDENCIES:  Bash, yad, Zenity, seqkit, shuf (coreutils)

VERSION INFORMATION: April 11, 2024 BT" --form --field="Your Initials for the log file" "Enter" --field="Name for new directory. This will be added to output filenames. CAUTION-No spaces or symbols" "Enter" --field="Remove entries containing Ns?:CB" 'NO!YES' --field="Create a two-column file from fasta:CB" 'NO!YES' --field="Change number of bases per row?:CB" 'NO!YES' --field="Number of bases per row - click box to manually edit:CBE" '50!60!80!100!150!200' --field="Randomly select entries?:CB" 'NO!YES' --field="Number of random entries - click box to manually edit:CBE" '10!50!100!150!200' --field="Subset fasta with list of known entries?:CB" 'NO!YES' --field="Select the file with list of samples for subsetting. Leave blank if none:FL" --field="Select the fasta file for processing:FL") 
echo $YADINPUT |  tr '|' '\t' | datamash transpose | head -n -1  > FMparameters1
########################################################################################################################################

a=$(awk 'NR==11 {if ($1=="") print "Missing_fasta_File"}' FMparameters1 )
awk -v var=$a 'NR==1 {if (var=="Missing_fasta_File") print "ERROR"}' FMparameters1 > EntryWarning
find . -name EntryWarning -type f -empty -delete
if [ -f "EntryWarning" ]; 
then
zenity --width 1200 --warning --text='<span font="32" foreground="red">YOU FORGOT TO ENTER THE FASTA FILE.  </span> \n Please close and start over.' --title="INFORMATION ENTRY FAILURE" 
rm EntryWarning FMparameters1 logo.jpeg
exit
fi
#######################################################################################################################
b=$(awk 'NR==2 {print $1}' FMparameters1)
mkdir ${b}
mv FMparameters1 ./${b}/
rm logo.jpeg
cd ${b}
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>FMt.log 2>&1
now=$(date)  
echo "Fasta Manipulatior (FM) Version 1.0
Program Started $now."
(#Start
echo "# Starting program"; sleep 2
c=$(awk 'NR==3 {print $1}' FMparameters1)
awk -v var=$c 'NR==1 {print "N"}' FMparameters1 > ${c}.nanswer
if [ -f "YES.nanswer" ]; 
then
#Get the file and strip it of any hidden formatting and convert tabs and spaces to :, Create a two column table and then remove any row that has an N in column 2, and convert back to fasta format
d=$(awk 'NR==11 {print $1}' FMparameters1)
sed $'s/[^[:print:]\t]//g' $d | tr ' ' ':' | tr '\t' ':' | awk 'BEGIN{RS=">"}NR>1{sub("\n","\t"); gsub("\n",""); print RS$0}' | awk -F'\t' '$2 !~"N"' | tr "\t" "\n" > TMPfasta
#and create a fasta with name for output 
e=$(awk 'NR==11 {print $1}' FMparameters1 | awk -F/ '{print $NF}' | sed 's/.fasta//g' | sed 's/.fa//g')
f=$(date +"%m_%d_%y_at_%H_%M")
cp TMPfasta ${e}_RemovedEntriesWithNs_${f}.fasta 
else 
d=$(awk 'NR==11 {print $1}' FMparameters1)
sed $'s/[^[:print:]\t]//g' $d | tr ' ' ':' | tr '\t' ':' | awk 'BEGIN{RS=">"}NR>1{sub("\n","\t"); gsub("\n",""); print RS$0}' | tr "\t" "\n" > TMPfasta
fi
rm *.nanswer
####Create a two column table 
g=$(awk 'NR==4 {print $1}' FMparameters1)
awk -v var=$g 'NR==1 {print "N"}' FMparameters1 > ${g}.tanswer
if [ -f "YES.tanswer" ]; 
then
e=$(awk 'NR==11 {print $1}' FMparameters1 | awk -F/ '{print $NF}' | sed 's/.fasta//g' | sed 's/.fa//g')
f=$(date +"%m_%d_%y_at_%H_%M")
awk 'BEGIN{RS=">"}NR>1{sub("\n","\t"); gsub("\n",""); print RS$0}' TMPfasta | tr ' ' '\t' > ${e}_TwoColumn_${f}.txt
fi 
rm *.tanswer


#User selected bases
h=$(awk 'NR==5 {print $1}' FMparameters1)
awk -v var=$g 'NR==1 {print "N"}' FMparameters1 > ${h}.banswer
if [ -f "YES.banswer" ]; 
then
e=$(awk 'NR==11 {print $1}' FMparameters1 | awk -F/ '{print $NF}' | sed 's/.fasta//g' | sed 's/.fa//g')
f=$(date +"%m_%d_%y_at_%H_%M")
i=$(awk 'NR==6 {print $1}' FMparameters1)
seqkit seq -w $i TMPfasta > ${e}_BasesPerLineAdjust_${f}.fasta
fi 
rm *.banswer

#Random subset 
m=$(awk 'NR==7 {print $1}' FMparameters1)
awk -v var=$h 'NR==1 {print "N"}' FMparameters1 > ${m}.ranswer
if [ -f "YES.ranswer" ]; 
then
e=$(awk 'NR==11 {print $1}' FMparameters1 | awk -F/ '{print $NF}' | sed 's/.fasta//g' | sed 's/.fa//g')
f=$(date +"%m_%d_%y_at_%H_%M")
j=$(awk 'NR==8 {print $1}' FMparameters1)
awk 'BEGIN{RS=">"}NR>1{sub("\n","\t"); gsub("\n",""); print RS$0}' TMPfasta | shuf -n $j  | tr "\t" "\n" > ${e}_${j}RandomSubset_${f}.fasta
fi 
rm *.ranswer

#Subset list 
k=$(awk 'NR==9 {print $1}' FMparameters1)
awk -v var=$k 'NR==1 {print "N"}' FMparameters1 > ${k}.sanswer
if [ -f "YES.sanswer" ]; 
then
e=$(awk 'NR==11 {print $1}' FMparameters1 | awk -F/ '{print $NF}' | sed 's/.fasta//g' | sed 's/.fa//g')
f=$(date +"%m_%d_%y_at_%H_%M")
l=$(awk 'NR==10 {print $1}' FMparameters1)
sed $'s/[^[:print:]\t]//g' $l | tr ' ' ':' | tr '\t' ':' > FMSubsetlist
awk 'BEGIN{RS=">"}NR>1{sub("\n","\t"); gsub("\n",""); print RS$0}' TMPfasta | grep -wFf FMSubsetlist - |  tr "\t" "\n" > ${e}_UserSubset_${f}.fasta
rm FMSubsetlist
fi 
rm *.sanswer
echo "95"

echo "# Tidying"; sleep 2 
rm TMPfasta
) | zenity --width 800 --title "PROGRESS" --progress --auto-close
now=$(date)
echo "Program Finished" $now.
printf 'Intitials of person running this program: \nName of directory \nRemove Ns?: \nCreate two column file?: \n Change number of bases per row?: \nNumber of bases per row if changed: \n Random subset of entries?: \nNumber of random entries if selected: \nSubset fasta with known entries list?" \n Path to subset list if chosen: \n Path to selected fasta file' > FMparam2
paste FMparam2 FMparameters1 > plog
f=$(date +"%m_%d_%y_at_%H_%M")
cat FMt.log plog > FM_${f}.log
rm FMt.log plog FMparam2 FMparameters1 
###########################################END OF PROGRAM###############################################################################
