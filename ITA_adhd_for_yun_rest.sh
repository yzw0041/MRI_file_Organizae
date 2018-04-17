#ITA old scans
#!/bin/bash


cd /Volumes/Pegasus_wangyun/ADHD/ITA/MRI/Raw/ADHD_for_yun/
rm Simon.txt
find ./*/*SIMON*/*.nii.gz -type f > ./Simon.txt #the new files

new_path=/Volumes/Pegasus_wangyun/ADHD/ITA/MRI/Raw/Preprocess  #the upper level

cat "Simon.txt" | while read C; do
       sub=`echo $C | cut -d'/' -f2`  #MRI folders
       echo $sub

       ff=`echo $C | cut -d'.' -f2`     #NIFTI files
       echo $ff



       if [ -d "$sub" ]; then
          echo "yes"
          #mkdir $new_path/$sub
          if [ -d "$new_path/sub-$sub/func" ]; then
              cp $C $new_path/sub-$sub/func/Simon.nii.gz
              cp .$ff.json  $new_path/sub-$sub/func/Simon.json

          else
              mkdir -p $new_path/sub-$sub/func  # -p can recursively make a new directory ;
              cp $C  $new_path/sub-$sub/func/Simon.nii.gz
              cp .$ff.json  $new_path/sub-$sub/func/Simon.json

          fi
          # count how many files inside this folder

          count=`ls $new_path/sub-$sub/func/sub*Simon*.nii.gz | wc -l`
          echo $(( count++))
          cp  $new_path/sub-$sub/func/Simon.nii.gz $new_path/sub-$sub/func/sub-${sub}_task-Simon_run-0${count}_bold.nii.gz
          cp  $new_path/sub-$sub/func/Simon.json $new_path/sub-$sub/func/sub-${sub}_task-Simon_run-0${count}_bold.json

          echo $new_path/sub-$sub/func/sub-${sub}_task-Simon_run-0${count}_bold.nii.gz>> $new_path/Simon_input.txt
          rm $new_path/sub-$sub/func/Simon.nii.gz
          rm $new_path/sub-$sub/func/Simon.json


       else
           echo "no"
       fi


done
