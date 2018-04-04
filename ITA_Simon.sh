#!/bin/bash


cd /Volumes/Pegasus_wangyun/ADHD/ITA/MRI/Raw

find ./*/*STRUC*/NIFTI/ -type f >> simon_update.txt #the new files
file2=./simon_update.txt

#find if simon.txt file already exist  ; this is the previous got

file1=./simon.txt
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
   echo "The previous simon.txt and the new simon_update.txt files are different"
   exit
fi






# simoning State MRI

#cat "simon.txt" | wc -l

 #find ./*/*simon_EPI_simoning*/NIFTI/ -type f >>simon.txt


 # count dimension and discard incomplete data; notice here 155 volumes ;

 cat "simon.txt" | while read C; do
        if  fslinfo $C | grep -q 155; then
            echo $C >> simon_complete_scans.txt
        else
            echo $C >> simon_incomplete_scans.txt
        fi

 done

# echo $(cat "simoning_incomplete_scans.txt"  | wc -l)


# There is only 7 scans not complete; Transfer the data to organized folder;

new_path='../Data/'  #the upper level

cat "simon.txt" | while read C; do
       sub=`echo $C | cut -d'/' -f2`  #MRI folders
       echo $sub

       ff=`echo $C | rev |  cut -d'/' -f1 | rev`    #NIFTI files
       echo $ff
       if [ -d "$sub" ]; then
          echo "yes"
          #mkdir $new_path/$sub
          if [ -d "$new_path/$sub/simon" ]; then
              cp $C  $new_path/$sub/simon/
          else
              mkdir -p $new_path/$sub/simon  # -p can recursively make a new directory ;
              cp $C  $new_path/$sub/simon

          fi
          # count how many files inside this folder
          count=`ls $new_path/$sub/simon/simon*.nii.gz | wc -l`
          echo $(( count++))
          cp  $new_path/$sub/simon/$ff  $new_path/$sub/simon/simon$count.nii.gz
          echo $new_path/$sub/simon/simon$count.nii.gz >> $new_path/simonomical_input.txt
          rm $new_path/$sub/simon/$ff


       else
           echo "no"
       fi

done
