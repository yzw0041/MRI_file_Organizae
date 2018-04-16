#!/bin/bash


cd /Volumes/Pegasus_wangyun/ADHD/ITA/MRI/Raw
rm rest_update.txt
find ./*/*Resting*/DICOM/ -type f >> rest_update.txt #the new files
file2=./rest_update.txt

#find if rest.txt file already exist  ; this is the previous got

file1=./rest.txt
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
   echo "The previous rest.txt and the new rest_update.txt files are different"
   exit
fi






# resting State MRI

#cat "rest.txt" | wc -l

 #find ./*/*rest_EPI_resting*/NIFTI/ -type f >>rest.txt


 #count dimension and discard incomplete data; notice here 155 volumes ;

 # cat "rest.txt" | while read C; do
 #        if  fslinfo $C | grep -q 155; then
 #            echo $C > rest_complete_scans.txt
 #        else
 #            echo $C > rest_incomplete_scans.txt
 #        fi
 #
 # done

# echo $(cat "resting_incomplete_scans.txt"  | wc -l)


# There is only 7 scans not complete; Transfer the data to organized folder;

new_path='../Preprocess/'  #the upper level

cat "rest.txt" | while read C; do
       sub=`echo $C | cut -d'/' -f2`  #MRI folders
       echo $sub

       ff=`echo $C | rev |  cut -d'/' -f1 | rev`    #NIFTI files
       echo $ff
       mkdir ./TT
       tar -zxvf $C -C  ./TT




      # for f in ./*MRDC*; do
      #   [ -e "$f" ] && echo "files do exist" || echo "files do not exist";
      #   mv *MRDC* ./TT
      #   dcm2niix TT
      #   rm ./TT/*MRDC*
      #
      #   mv *.dcm ./TT
      #   dcm2niix TT
      #   rm ./TT/*.dcm
      #
      #
      #  break;
      #  done

           #mv *.dcm ./TT
      dcm2niix TT
           #rm ./TT/*.dcm



       if [ -d "$sub" ]; then
          echo "yes"
          #mkdir $new_path/$sub
          if [ -d "$new_path/sub-$sub/func" ]; then
              cp ./TT/*Rest*.nii.gz  $new_path/sub-$sub/func/rest.nii.gz
              cp ./TT/*Rest*.json  $new_path/sub-$sub/func/rest.json

          else
              mkdir -p $new_path/sub-$sub/func # -p can recursively make a new directory ;
              cp ./TT/*Rest*.nii.gz  $new_path/sub-$sub/func/rest.nii.gz
              cp ./TT/*Rest*.json  $new_path/sub-$sub/func/rest.json

          fi
          # count how many files inside this folder
          rm ./TT/*Rest*.nii.gz
          rm ./TT/*Rest*.json
          count=`ls $new_path/sub-$sub/func/sub*rest*.nii.gz | wc -l`
          echo $(( count++))
          cp  $new_path/sub-$sub/func/rest.nii.gz $new_path/sub-$sub/func/sub-${sub}_task-rest_run-0${count}_bold.nii.gz
          cp  $new_path/sub-$sub/func/rest.json $new_path/sub-$sub/func/sub-${sub}_task-rest_run-0${count}_bold.json

          echo $new_path/sub-$sub/func/sub-${sub}_task-rest_run-0${count}_bold.nii.gz >> $new_path/rest_input.txt
          rm $new_path/sub-$sub/func/rest.nii.gz
          rm $new_path/sub-$sub/func/rest.json


       else
           echo "no"
       fi
       rm *MRDC*
       rm *.dcm
       rm -R ./TT

done
