#!/bin/bash
source project.sh

: '
wrapper script for DEXI ASL images preprocessing
requirements: fsl, AFNI, ANTs, MATLAB
Davide Di Censo PhD based on the scripts developed by Antonio Maria Chiarelli @ITAB 2024
'

function final_images() {
   if [ -f $WRK_DIR/${SUBJ}_task-rest_run-02_desc-preproc_asl.nii.gz ]; then
      echo "Images already splitted...skipping to next task"
   else
      echo "Splitting images..."
      fslroi $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_asl_topup.nii.gz $WRK_DIR/${SUBJ}_task-rest_run-01_desc-preproc_asl.nii.gz 0 103
      fslroi $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_asl_topup.nii.gz $WRK_DIR/${SUBJ}_task-glove_dexi_desc-preproc_asl.nii.gz 112 196
      fslroi $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_asl_topup.nii.gz $WRK_DIR/${SUBJ}_task-rest_run-02_desc-preproc_asl.nii.gz 308 102
   fi
}

function calc_cbf() {
   if [ -f $WRK_DIR/${SUBJ}_task-rest_run-01_desc-preproc_asl_CBF_map.nii.gz ]; then
      echo "CBF maps already calculated...skipping to next task"
   else
      echo "Calculating resting CBF maps..."
      matlab -nodisplay -r "cd('$CODE_DIR/Analysis/'); ASL_CBF('$WRK_DIR/${SUBJ}_task-rest_run-01_desc-preproc_asl.nii.gz','$M0'); exit"
      matlab -nodisplay -r "cd('$CODE_DIR/Analysis/'); ASL_CBF('$WRK_DIR/${SUBJ}_task-glove_dexi_desc-preproc_asl.nii.gz','$M0'); exit"
      matlab -nodisplay -r "cd('$CODE_DIR/Analysis/'); ASL_CBF('$WRK_DIR/${SUBJ}_task-rest_run-02_desc-preproc_asl.nii.gz','$M0'); exit"
      gzip -f $WRK_DIR/*nii
   fi
}

function calc_bh_maps() {
   if [ -f $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_asl_topup_BOLDCVR_map.nii.gz ]; then
     echo "Bh parametrical maps already calculated...skipping to next task"
   else
      echo "Calculating BH parametrical maps..."
      matlab -nodisplay -r "cd('$CODE_DIR/Analysis/'); CALfMRI('$WRK_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_asl_topup.nii.gz','$M0','$FUNC_DIR/${SUBJ}_task-bh_run-01_dexi_desc-despike_bold.nii.gz'); exit"
      matlab -nodisplay -r "cd('$CODE_DIR/Analysis/'); CALfMRI('$WRK_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_asl_topup.nii.gz','$M0','$FUNC_DIR/${SUBJ}_task-bh_run-02_dexi_desc-despike_bold.nii.gz'); exit"
      # gzip $WRK_DIR/*nii
   fi
}

function mask_cbf() {
   if [ -f $WRK_DIR/${SUBJ}_task-rest_run-01_desc-preproc_asl_CBF_map_masked.nii.gz ]; then
      echo "masking already done...skipping to next task"
   else
      fslmaths $WRK_DIR/${SUBJ}_task-rest_run-01_desc-preproc_asl_CBF_map.nii.gz -mas $ASL_MASK $WRK_DIR/${SUBJ}_task-rest_run-01_desc-preproc_asl_CBF_map_masked.nii.gz
      fslmaths $WRK_DIR/${SUBJ}_task-glove_dexi_desc-preproc_asl_CBF_map.nii.gz -mas $ASL_MASK $WRK_DIR/${SUBJ}_task-glove_dexi_desc-preproc_asl_CBF_map_masked.nii.gz
      fslmaths $WRK_DIR/${SUBJ}_task-rest_run-02_desc-preproc_asl_CBF_map.nii.gz -mas $ASL_MASK $WRK_DIR/${SUBJ}_task-rest_run-02_desc-preproc_asl_CBF_map_masked.nii.gz
   fi
}

function blur_images() {
   if [ -f $REG_DIR/${SUBJ}_rest1_CBF_map_blurred.nii.gz ]; then
      echo "CBF maps already blurred...skipping to next task"
   else
   # select best algorithm
      # 3dBlurInMask -overwrite -input $WRK_DIR/${SUBJ}_rest1_CBF_map_to_template.nii.gz -fwhm $FWHM -mask $ATLAS_MASK_CBF -pM0ix $REG_DIR/${SUBJ}_rest1_CBF_map_blurred.nii.gz
      fslmaths $WRK_DIR/${SUBJ}_task-rest_run-01_desc-preproc_asl_CBF_map_masked.nii.gz -s $FWHM $WRK_DIR/${SUBJ}_task-rest_run-01_desc-preproc_asl_CBF_map_blurred.nii.gz
      fslmaths $WRK_DIR/${SUBJ}_task-rest_run-02_desc-preproc_asl_CBF_map_masked.nii.gz -s $FWHM $WRK_DIR/${SUBJ}_task-rest_run-02_desc-preproc_asl_CBF_map_blurred.nii.gz
   fi
}

function warp_images() {
   if [ -f $REG_DIR/perf/${SUBJ}_task-rest_desc-preproc_asl_CBF_map_differences.nii.gz ]; then
      echo "warping already done...skipping to next task"
   else
      MAPS=('CVR' 'CMRO2' 'OEF')

      TMFS="-t $ANAT_DIR/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1Warp.nii.gz -t $ANAT_DIR/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_0GenericAffine.mat"

      for MAP in ${MAPS[@]}; do
         antsApplyTransforms -d 3 -i $WRK_DIR/outcome/${SUBJ}_task-bh_run-01_dexi_volreg_asl_topup_${MAP}_map.nii.gz -r $ATLAS2 -o $REG_DIR/perf/${SUBJ}_task-bh_run-01_dexi_volreg_asl_topup_${MAP}_map.nii.gz $TMFS -t $PROC_DIR/$SUBJ/func/${SUBJ}_run1toanat_0GenericAffine.mat
         antsApplyTransforms -d 3 -i $WRK_DIR/outcome/${SUBJ}_task-bh_run-02_dexi_volreg_asl_topup_${MAP}_map.nii.gz -r $ATLAS2 -o $REG_DIR/perf/${SUBJ}_task-bh_run-02_dexi_volreg_asl_topup_${MAP}_map.nii.gz $TMFS -t $PROC_DIR/$SUBJ/func/${SUBJ}_run2toanat_0GenericAffine.mat

         fslmaths $REG_DIR/perf/${SUBJ}_task-bh_run-02_dexi_volreg_asl_topup_${MAP}_map.nii.gz -sub $REG_DIR/perf/${SUBJ}_task-bh_run-01_dexi_volreg_asl_topup_${MAP}_map.nii.gz $REG_DIR/perf/${SUBJ}_task-bh_dexi_volreg_asl_${MAP}_differences.nii.gz
      done

      INV_TMFS="-t [ $ANAT_DIR/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_0GenericAffine.mat , 1 ] -t $ANAT_DIR/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1InverseWarp.nii.gz"
      antsApplyTransforms -d 3 -i $LABELS -r $M0 -o $WRK_DIR/${SUBJ}_task-bh_run-01_labels.nii.gz -n Multilabel -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run1toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      antsApplyTransforms -d 3 -i $LABELS -r $M0 -o $PROC_DIR/${SUBJ}/func/${SUBJ}_task-bh_run-01_labels.nii.gz -n Multilabel -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run1toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      antsApplyTransforms -d 3 -i $LABELS -r $M0 -o $WRK_DIR/${SUBJ}_task-bh_run-02_labels.nii.gz -n Multilabel -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run2toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      antsApplyTransforms -d 3 -i $LABELS -r $M0 -o $PROC_DIR/${SUBJ}/func/${SUBJ}_task-bh_run-02_labels.nii.gz -n Multilabel -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run2toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      
      antsApplyTransforms -d 3 -i $ANAT_DIR/${SUBJ}_desc-UNI_MP2RAGE_brain_pve_1.nii.gz -r $M0 -o $PROC_DIR/${SUBJ}/perf/${SUBJ}_brain_pve_1.nii.gz -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run1toanat_0GenericAffine.mat , 1 ]

      fslmaths $WRK_DIR/${SUBJ}_task-rest_run-02_desc-preproc_asl_CBF_map_masked.nii.gz -sub $WRK_DIR/${SUBJ}_task-rest_run-01_desc-preproc_asl_CBF_map_masked.nii.gz $WRK_DIR/${SUBJ}_task-rest_desc-preproc_asl_CBF_map_differences.nii.gz

      antsApplyTransforms -d 3 -i $WRK_DIR/${SUBJ}_task-rest_desc-preproc_asl_CBF_map_differences.nii.gz -r $ATLAS2 -o $REG_DIR/perf/${SUBJ}_task-rest_desc-preproc_asl_CBF_map_differences.nii.gz $TMFS -t $PROC_DIR/$SUBJ/func/${SUBJ}_tasktoanat_0GenericAffine.mat
      antsApplyTransforms -d 3 -i $WRK_DIR/${SUBJ}_task-rest_run-01_desc-preproc_asl_CBF_map_masked.nii.gz -r $ATLAS2 -o $REG_DIR/perf/${SUBJ}_task-rest_run-01_desc-preproc_asl_CBF_map_masked.nii.gz $TMFS -t $PROC_DIR/$SUBJ/func/${SUBJ}_tasktoanat_0GenericAffine.mat
      antsApplyTransforms -d 3 -i $WRK_DIR/${SUBJ}_task-rest_run-02_desc-preproc_asl_CBF_map_masked.nii.gz -r $ATLAS2 -o $REG_DIR/perf/${SUBJ}_task-rest_run-02_desc-preproc_asl_CBF_map_masked.nii.gz $TMFS -t $PROC_DIR/$SUBJ/func/${SUBJ}_tasktoanat_0GenericAffine.mat
      fslmaths $REG_DIR/perf/${SUBJ}_task-rest_run-02_desc-preproc_asl_CBF_map_masked.nii.gz -sub $REG_DIR/perf/${SUBJ}_task-rest_run-01_desc-preproc_asl_CBF_map_masked.nii.gz $REG_DIR/perf/${SUBJ}_task-rest_desc-preproc_asl_CBF_differences.nii.gz

      ## warp yeo 7 network mask to subj space
      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_dmn_1mm.nii.gz -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-01_dmn.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run1toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_dorsalattention_1mm.nii.gz  -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-01_dorsalattention.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run1toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_frontoparietal_1mm.nii.gz -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-01_frontoparietal.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run1toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_limbic_1mm.nii.gz -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-01_limbic.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run1toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_somatomotor_1mm.nii.gz -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-01_somatomotor.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run1toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_ventralattention_1mm.nii.gz -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-01_ventralattention.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run1toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_visual_1mm.nii.gz -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-01_visual.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run1toanat_0GenericAffine.mat , 1 ] $INV_TMFS

      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_dmn_1mm.nii.gz -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-02_dmn.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run2toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_dorsalattention_1mm.nii.gz  -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-02_dorsalattention.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run2toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_frontoparietal_1mm.nii.gz -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-02_frontoparietal.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run2toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_limbic_1mm.nii.gz -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-02_limbic.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run2toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_somatomotor_1mm.nii.gz -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-02_somatomotor.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run2toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_ventralattention_1mm.nii.gz -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-02_ventralattention.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run2toanat_0GenericAffine.mat , 1 ] $INV_TMFS
      ##antsApplyTransforms -d 3 -i $ATLAS_DIR/Yeo/Yeo7Network_visual_1mm.nii.gz -r $M0 -o $WRK_DIR/outcome/${SUBJ}_task-bh_run-02_visual.nii.gz -n NearestNeighbor -t [ $PROC_DIR/${SUBJ}/func/${SUBJ}_run2toanat_0GenericAffine.mat , 1 ] $INV_TMFS

   fi
}

fortune
FWHM=4.5
mapfile -t SCANS < subjects.txt #read subjects from textfile

# SUBJ=$1
for SUBJ in ${SCANS[@]}; do
   sleep 2
   cowsay Processing: $SUBJ
   # folder definitions
   WRK_DIR=$PROC_DIR/$SUBJ/perf   
   ANAT_DIR="$PROC_DIR/${SUBJ}/anat"
   FUNC_DIR="$PROC_DIR/${SUBJ}/func"
   mkdir -p $WRK_DIR/outcome
   mkdir -p $REG_DIR/perf
   cd $WRK_DIR

   # set filenames
   ASL=$WRK_DIR/${SUBJ}_volreg_topup_asl.nii.gz # edit with the raw DEXI asl path
   ASL_MASK="$WRK_DIR/${SUBJ}_acq-M0_dir-AP_dexi_brain_mask.nii.gz"
   M0="$WRK_DIR/${SUBJ}_acq-M0_dir-AP_dexi_brain.nii.gz"
   labels="$ANAT_DIR/${SUBJ}_labels.nii.gz"

   final_images
   calc_cbf
   calc_bh_maps
   mask_cbf
   blur_images
   warp_images
done
