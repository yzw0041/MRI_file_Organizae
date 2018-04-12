#!/bin/bash


cd /Volumes/Pegasus_wangyun/ADHD/ITA/MRI/Raw
rm anat_update.txt
find ./*/*STRUC*/NIFTI/ -type f >> anat_update.txt #the new files
file2=./anat_update.txt

#find if anat.txt file already exist  ; this is the previous got

file1=./anat.txt
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
   echo "The previous anat.txt and the new anat_update.txt files are different"
   exit
fi






# anating State MRI

#cat "anat.txt" | wc -l

 #find ./*/*anat_EPI_anating*/NIFTI/ -type f >>anat.txt


 # count dimension and discard incomplete data; notice here 155 volumes ;

 # cat "anat.txt" | while read C; do
 #        if  fslinfo $C | grep -q 155; then
 #            echo $C >> anat_complete_scans.txt
 #        else
 #            echo $C >> anat_incomplete_scans.txt
 #        fi
 #
 # done

# echo $(cat "anating_incomplete_scans.txt"  | wc -l)


# There is only 7 scans not complete; Transfer the data to organized folder;

new_path='../Data/'  #the upper level

cat "anat.txt" | while read C; do
       sub=`echo $C | cut -d'/' -f2`  #MRI folders
       echo $sub

       ff=`echo $C | rev |  cut -d'/' -f1 | rev`    #NIFTI files
       echo $ff
       if [ -d "$sub" ]; then
          echo "yes"
          #mkdir $new_path/$sub
          if [ -d "$new_path/sub-$sub/anat" ]; then
              cp $C  $new_path/sub-$sub/anat/anat.nii.gz
          else
              mkdir -p $new_path/sub-$sub/anat  # -p can recursively make a new directory ;
              cp $C  $new_path/sub-$sub/anat/anat.nii.gz

          fi
          # count how many files inside this folder
          count=`ls $new_path/sub-$sub/anat/sub*.nii.gz | wc -l`
          echo $(( count++))
          cp  $new_path/sub-$sub/anat/anat.nii.gz $new_path/sub-$sub/anat/sub-${sub}_run-0${count}_T1w.nii.gz
          echo $new_path/sub-$sub/anat/sub-${sub}_run-0${count}_T1w.nii.gz >> $new_path/anatomical_input.txt
          rm $new_path/sub-$sub/anat/anat.nii.gz


       else
           echo "no"
       fi

done
