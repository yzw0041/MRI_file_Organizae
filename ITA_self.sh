#!/bin/bash


cd /Volumes/Pegasus_wangyun/ADHD/ITA/MRI/Raw

find ./*/*Self*/NIFTI/ -type f >> self_update.txt #the new files
file2=./self_update.txt

#find if self.txt file already exist  ; this is the previous got

file1=./self.txt
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
   echo "The previous self.txt and the new self_update.txt files are different"
   exit
fi






# selfing State MRI

#cat "self.txt" | wc -l

 #find ./*/*self_EPI_selfing*/NIFTI/ -type f >>self.txt


 # count dimension and discard incomplete data; notice here 155 volumes ;

 cat "self.txt" | while read C; do
        if  fslinfo $C | grep -q 155; then
            echo $C >> self_complete_scans.txt
        else
            echo $C >> self_incomplete_scans.txt
        fi

 done

# echo $(cat "selfing_incomplete_scans.txt"  | wc -l)


# There is only 7 scans not complete; Transfer the data to organized folder;

new_path='../Data/'  #the upper level

cat "self.txt" | while read C; do
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
          #count=`ls $new_path/$sub/self/self*.nii.gz | wc -l`
          #echo $(( count++))
          cp  $new_path/$sub/func/$ff  $new_path/$sub/func/self$count.nii.gz
          echo $new_path/$sub/func/self$count.nii.gz >> $new_path/self_input.txt
          rm $new_path/$sub/func/$ff
          #rm $new_path/$sub/func/self$oldcount.nii.gz


       else
           echo "no"
       fi

done
