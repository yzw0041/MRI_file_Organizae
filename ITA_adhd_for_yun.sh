#ITA old scans
#!/bin/bash


cd /Volumes/Pegasus_wangyun/ADHD/ITA/MRI/Raw/ADHD_for_yun/
#rm anat.txt
find ./*/*SAG3D*/*.nii.gz -type f > ./anat.txt #the new files

new_path=/Volumes/Pegasus_wangyun/ADHD/ITA/MRI/Raw/Preprocess  #the upper level

cat "anat.txt" | while read C; do
       sub=`echo $C | cut -d'/' -f2`  #MRI folders
       echo $sub

       ff=`echo $C | cut -d'.' -f2`     #NIFTI files
       echo $ff



       if [ -d "$sub" ]; then
          echo "yes"
          #mkdir $new_path/$sub
          if [ -d "$new_path/sub-$sub/anat" ]; then
              cp $C $new_path/sub-$sub/anat/anat.nii.gz
              cp .$ff.json  $new_path/sub-$sub/anat/anat.json

          else
              mkdir -p $new_path/sub-$sub/anat  # -p can recursively make a new directory ;
              cp $C  $new_path/sub-$sub/anat/anat.nii.gz
              cp .$ff.json  $new_path/sub-$sub/anat/anat.json

          fi
          # count how many files inside this folder

          count=`ls $new_path/sub-$sub/anat/sub*.nii.gz | wc -l`
          echo $(( count++))
          cp  $new_path/sub-$sub/anat/anat.nii.gz $new_path/sub-$sub/anat/sub-${sub}_run-0${count}_T1w.nii.gz
          cp  $new_path/sub-$sub/anat/anat.json $new_path/sub-$sub/anat/sub-${sub}_run-0${count}_T1w.json

          echo $new_path/sub-$sub/anat/sub-${sub}_run-0${count}_T1w.nii.gz >> $new_path/anatomical_input.txt
          rm $new_path/sub-$sub/anat/anat.nii.gz
          rm $new_path/sub-$sub/anat/anat.json


       else
           echo "no"
       fi


done
