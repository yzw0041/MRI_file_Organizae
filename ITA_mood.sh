#!/bin/bash


cd /Volumes/Pegasus_wangyun/ADHD/ITA/MRI/Raw

find ./*/*Mood*/NIFTI/ -type f >> mood_update.txt #the new files
file2=./mood_update.txt

#find if mood.txt file already exist  ; this is the previous got

file1=./mood.txt
if [ -e "$file1" ]; then
    echo "File exists"
else
    echo "File does not exist"
fi

#compare the two files are same or not

if cmp -s "$file1" "$file2"
then
   echo "The files match"
else
   echo "The previous mood.txt and the new mood_update.txt files are different"
   exit
fi






# mooding State MRI

#cat "mood.txt" | wc -l

 #find ./*/*mood_EPI_mooding*/NIFTI/ -type f >>mood.txt


 # count dimension and discard incomplete data; notice here 155 volumes ;

 cat "mood.txt" | while read C; do
        if  fslinfo $C | grep -q 155; then
            echo $C >> mood_complete_scans.txt
        else
            echo $C >> mood_incomplete_scans.txt
        fi

 done

# echo $(cat "mooding_incomplete_scans.txt"  | wc -l)


# There is only 7 scans not complete; Transfer the data to organized folder;

new_path='../Data/'  #the upper level

cat "mood.txt" | while read C; do
       sub=`echo $C | cut -d'/' -f2`  #MRI folders
       echo $sub

       ff=`echo $C | rev |  cut -d'/' -f1 | rev`    #NIFTI files
       echo $ff
       if [ -d "$sub" ]; then
          echo "yes"
          #mkdir $new_path/$sub
          if [ -d "$new_path/$sub/func" ]; then
              cp $C  $new_path/$sub/func/
          else
              mkdir -p $new_path/$sub/func # -p can recursively make a new directory ;
              cp $C  $new_path/$sub/func

          fi
          # count how many files inside this folder
          tt=`echo $ff | cut -d'.' -f-1`
          #oldcount=${tt: -6:1}
          count=${tt: -7:2}
          #count=`ls $new_path/$sub/mood/mood*.nii.gz | wc -l`
          #echo $(( count++))
          cp  $new_path/$sub/func/$ff  $new_path/$sub/func/mood$count.nii.gz
          echo $new_path/$sub/func/mood$count.nii.gz >> $new_path/mood_input.txt
          rm $new_path/$sub/func/$ff
          #rm $new_path/$sub/func/mood$oldcount.nii.gz


       else
           echo "no"
       fi

done
