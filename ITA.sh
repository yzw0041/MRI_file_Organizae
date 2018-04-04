#!/bin/bash


cd /Volumes/Pegasus_wangyun/ADHD/ITA/MRI/Raw

%find ./*/*FUNC_EPI_Resting*/NIFTI/ -type f >> rest_update.txt % the new files
file2=./rest_update.txt

% find if rest.txt file already exist  ; this is the previous got

file1=./rest.txt
if [ -e "$file1" ]; then
    echo "File exists"
else
    echo "File does not exist"
fi

%% compare the two files are same or not

if cmp -s "$file1" "$file2"
then
   echo "The files match"
else
   echo "The previous rest.txt and the new rest_update.txt files are different"
   exit
fi






% resting State MRI

cat "rest.txt" | wc -l

 find ./*/*FUNC_EPI_Resting*/NIFTI/ -type f >>rest.txt


 % count dimension and discard incomplete data; notice here 155 volumes ;

 cat "rest.txt" | while read C; do
        if  fslinfo $C | grep -q 155; then
            echo $C >> resting_complete_scans.txt
        else
            echo $C >> resting_incomplete_scans.txt
        fi

 done

echo $(cat "resting_incomplete_scans.txt"  | wc -l)


% There is only 7 scans not complete; Transfer the data to organized folder;

new_path='../Data/'  #the upper level

cat "resting_complete_scans.txt" | while read C; do
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
              mkdir -p $new_path/$sub/func  # -p can recursively make a new directory ;
              cp $C  $new_path/$sub/func

          fi
          # count how many files inside this folder
          count=`ls $new_path/$sub/func/rest*.nii.gz | wc -l`
          echo $(( count++))
          cp  $new_path/$sub/func/$ff  $new_path/$sub/func/rest$count.nii.gz
          echo $new_path/$sub/func/rest$count.nii.gz >> $new_path/resting_functional_input.txt
          rm $new_path/$sub/func/$ff


       else
           echo "no"
       fi

done
