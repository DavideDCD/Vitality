#!/bin/bash
source project.sh

: '
wrapper script for fMRI BOLD images preprocessing
requirements: fsl, AFNI, ANTs
remember to edit project.sh
Davide Di Censo, based on the scripts developed by Antonio Maria Chiarelli and Alessandra Stella Caporale @ITAB 2024
'

# function definitions
function motion_correction() {
   if [ -f $PERF_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_asl.nii.gz ]; then
     echo "Motion_correction already done...skipping to next task"
   else
      # execute motion correction script written by ASC
      # this will produce motion corrected ASL and BOLD images in perf and func folders 

      # DEXI task-bh run-01
      bash $CODE_DIR/DEXI_motion_correction/DEXI_preprocessing_optimization.sh $ROOT_DIR/$SUBJ/func/${SUBJ}_task-bh_run-01_dexi_bold.nii.gz $ROOT_DIR/$SUBJ/perf/${SUBJ}_task-bh_run-01_dexi_asl.nii.gz $WRK_DIR
      mv $WRK_DIR/tag_asl_realigned.nii.gz $PERF_DIR/tag_asl_realigned.nii.gz
      mv $WRK_DIR/ctrl_asl_realigned.nii.gz $PERF_DIR/ctrl_asl_realigned.nii.gz
      python3 $CODE_DIR/DEXI_motion_correction/img_interleave.py --volume1 $WRK_DIR/tag_bold_realigned.nii.gz --volume2 $WRK_DIR/ctrl_bold_realigned.nii.gz --output-directory $WRK_DIR --outname ${SUBJ}_task-bh_run-01_dexi_volreg_bold.nii.gz
      python3 $CODE_DIR/DEXI_motion_correction/img_interleave.py --volume1 $PERF_DIR/tag_asl_realigned.nii.gz --volume2 $PERF_DIR/ctrl_asl_realigned.nii.gz --output-directory $PERF_DIR --outname ${SUBJ}_task-bh_run-01_dexi_volreg_asl.nii.gz

      fslmerge -tr $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_bold.nii.gz $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_bold.nii.gz $TR_secs
      fslmerge -tr $PERF_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_asl.nii.gz $PERF_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_asl.nii.gz $TR_secs

      rm -r $WRK_DIR/BOLD
      rm -r $WRK_DIR/ASL

      rm $WRK_DIR/tag_bold_realigned.nii.gz $PERF_DIR/tag_asl_realigned.nii.gz $PERF_DIR/ctrl_asl_realigned.nii.gz $WRK_DIR/ctrl_bold_realigned.nii.gz

      # DEXI task- rest - glove - rest
      bash $CODE_DIR/DEXI_motion_correction/DEXI_preprocessing_optimization.sh $ROOT_DIR/$SUBJ/func/${SUBJ}_dexi_REST_TASK_REST.nii.gz $ROOT_DIR/$SUBJ/perf/${SUBJ}_dexi_REST_TASK_REST.nii.gz $WRK_DIR
      mv $WRK_DIR/tag_asl_realigned.nii.gz $PERF_DIR/tag_asl_realigned.nii.gz
      mv $WRK_DIR/ctrl_asl_realigned.nii.gz $PERF_DIR/ctrl_asl_realigned.nii.gz
      python3 $CODE_DIR/DEXI_motion_correction/img_interleave.py --volume1 $WRK_DIR/tag_bold_realigned.nii.gz --volume2 $WRK_DIR/ctrl_bold_realigned.nii.gz --output-directory $WRK_DIR --outname ${SUBJ}_dexi_REST_TASK_REST_volreg_bold.nii.gz
      python3 $CODE_DIR/DEXI_motion_correction/img_interleave.py --volume1 $PERF_DIR/tag_asl_realigned.nii.gz --volume2 $PERF_DIR/ctrl_asl_realigned.nii.gz --output-directory $PERF_DIR --outname ${SUBJ}_dexi_REST_TASK_REST_volreg_asl.nii.gz

      fslmerge -tr $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_bold.nii.gz $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_bold.nii.gz $TR_secs
      fslmerge -tr $PERF_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_asl.nii.gz $PERF_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_asl.nii.gz $TR_secs

      rm -r $WRK_DIR/BOLD
      rm -r $WRK_DIR/ASL

      rm $WRK_DIR/tag_bold_realigned.nii.gz $PERF_DIR/tag_asl_realigned.nii.gz $PERF_DIR/ctrl_asl_realigned.nii.gz $WRK_DIR/ctrl_bold_realigned.nii.gz


      # DEXI task-bh run-02
      bash $CODE_DIR/DEXI_motion_correction/DEXI_preprocessing_optimization.sh $ROOT_DIR/$SUBJ/func/${SUBJ}_task-bh_run-02_dexi_bold.nii.gz $ROOT_DIR/$SUBJ/perf/${SUBJ}_task-bh_run-02_dexi_asl.nii.gz $WRK_DIR
      mv $WRK_DIR/tag_asl_realigned.nii.gz $PERF_DIR/tag_asl_realigned.nii.gz
      mv $WRK_DIR/ctrl_asl_realigned.nii.gz $PERF_DIR/ctrl_asl_realigned.nii.gz
      python3 $CODE_DIR/DEXI_motion_correction/img_interleave.py --volume1 $WRK_DIR/tag_bold_realigned.nii.gz --volume2 $WRK_DIR/ctrl_bold_realigned.nii.gz --output-directory $WRK_DIR --outname ${SUBJ}_task-bh_run-02_dexi_volreg_bold.nii.gz
      python3 $CODE_DIR/DEXI_motion_correction/img_interleave.py --volume1 $PERF_DIR/tag_asl_realigned.nii.gz --volume2 $PERF_DIR/ctrl_asl_realigned.nii.gz --output-directory $PERF_DIR --outname ${SUBJ}_task-bh_run-02_dexi_volreg_asl.nii.gz
   
      fslmerge -tr $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_bold.nii.gz $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_bold.nii.gz $TR_secs
      fslmerge -tr $PERF_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_asl.nii.gz $PERF_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_asl.nii.gz $TR_secs

      rm -r $WRK_DIR/BOLD
      rm -r $WRK_DIR/ASL

      rm $WRK_DIR/tag_bold_realigned.nii.gz $PERF_DIR/tag_asl_realigned.nii.gz $PERF_DIR/ctrl_asl_realigned.nii.gz $WRK_DIR/ctrl_bold_realigned.nii.gz
   fi
}

function run_topup() {
   # estimate field bias distorsion from blip-up blip-down M0 images
   # and correct DEXI image applying the correction
   if [ -f $PERF_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_asl_topup.nii.gz ]; then
      echo "Topup already done...skipping to next task"
   else
      mkdir -p $WRK_DIR/topup/

      # creating AP - PA file
      fslmerge -t $WRK_DIR/topup/${SUBJ}_acq-M0_dir-AP_PA_dexi.nii.gz $ROOT_DIR/$SUBJ/fmap/${SUBJ}_acq-M0_dir-AP_dexi.nii.gz $ROOT_DIR/$SUBJ/fmap/${SUBJ}_acq-M0_dir-PA_dexi.nii.gz
      
      # since z dimension is odd topup will crash, so we add a zero-padded slice at the bottom of the brain
      3dZeropad -S 1 -overwrite -prefix $WRK_DIR/topup/${SUBJ}_acq-M0_dir-AP_PA_dexi_padded.nii.gz $WRK_DIR/topup/${SUBJ}_acq-M0_dir-AP_PA_dexi.nii.gz 
      
      # running topup
      echo "bias field estimation"
      topup --imain=$WRK_DIR/topup/${SUBJ}_acq-M0_dir-AP_PA_dexi_padded.nii.gz --datain=$SCRIPT_DIR/acqparams.txt --config=b02b0.cnf --out=$WRK_DIR/topup/topup
      
      echo "padding images"
      3dZeropad -S 1 -overwrite -prefix $WRK_DIR/topup/${SUBJ}_acq-M0_dir-AP_dexi_padded.nii.gz $ROOT_DIR/$SUBJ/fmap/${SUBJ}_acq-M0_dir-AP_dexi.nii.gz
      3dZeropad -S 1 -overwrite -prefix $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_bold_padded.nii.gz  $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_bold.nii.gz
      3dZeropad -S 1 -overwrite -prefix $PERF_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_asl_padded.nii.gz  $PERF_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_asl.nii.gz
      3dZeropad -S 1 -overwrite -prefix $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_bold_padded.nii.gz  $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_bold.nii.gz
      3dZeropad -S 1 -overwrite -prefix $PERF_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_asl_padded.nii.gz  $PERF_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_asl.nii.gz
      3dZeropad -S 1 -overwrite -prefix $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_bold_padded.nii.gz  $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_bold.nii.gz
      3dZeropad -S 1 -overwrite -prefix $PERF_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_asl_padded.nii.gz  $PERF_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_asl.nii.gz
      # apply topup
      echo "correcting images"
      applytopup --imain=$WRK_DIR/topup/${SUBJ}_acq-M0_dir-AP_dexi_padded.nii.gz --inindex=1 --datain=$SCRIPT_DIR/acqparams.txt --topup=$WRK_DIR/topup/topup --method=jac --out=$PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_corrected.nii.gz
      applytopup --imain=$WRK_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_bold_padded.nii.gz --inindex=1 --datain=$SCRIPT_DIR/acqparams.txt --topup=$WRK_DIR/topup/topup --method=jac --out=$WRK_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_bold_corrected.nii.gz
      applytopup --imain=$PERF_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_asl_padded.nii.gz --inindex=1 --datain=$SCRIPT_DIR/acqparams.txt --topup=$WRK_DIR/topup/topup --method=jac --out=$PERF_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_asl_corrected.nii.gz
      applytopup --imain=$WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_bold_padded.nii.gz --inindex=1 --datain=$SCRIPT_DIR/acqparams.txt --topup=$WRK_DIR/topup/topup --method=jac --out=$WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_bold_corrected.nii.gz
      applytopup --imain=$PERF_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_asl_padded.nii.gz --inindex=1 --datain=$SCRIPT_DIR/acqparams.txt --topup=$WRK_DIR/topup/topup --method=jac --out=$PERF_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_asl_corrected.nii.gz
      applytopup --imain=$WRK_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_bold_padded.nii.gz --inindex=1 --datain=$SCRIPT_DIR/acqparams.txt --topup=$WRK_DIR/topup/topup --method=jac --out=$WRK_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_bold_corrected.nii.gz
      applytopup --imain=$PERF_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_asl_padded.nii.gz --inindex=1 --datain=$SCRIPT_DIR/acqparams.txt --topup=$WRK_DIR/topup/topup --method=jac --out=$PERF_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_asl_corrected.nii.gz
      # delete the extra slice
      echo "removing the extra slice"
      3dZeropad -S -1 -overwrite -prefix $PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi.nii.gz $PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_corrected.nii.gz 
      3dZeropad -S -1 -overwrite -prefix $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_bold_topup.nii.gz  $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_bold_corrected.nii.gz
      3dZeropad -S -1 -overwrite -prefix $PERF_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_asl_topup.nii.gz  $PERF_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_asl_corrected.nii.gz
      3dZeropad -S -1 -overwrite -prefix $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_bold_topup.nii.gz  $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_bold_corrected.nii.gz
      3dZeropad -S -1 -overwrite -prefix $PERF_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_asl_topup.nii.gz  $PERF_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_asl_corrected.nii.gz
      3dZeropad -S -1 -overwrite -prefix $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_bold_topup.nii.gz  $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_bold_corrected.nii.gz
      3dZeropad -S -1 -overwrite -prefix $PERF_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_asl_topup.nii.gz  $PERF_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_asl_corrected.nii.gz

      # create 3D M0 image for asl processing and registration purposes 
      fslmaths $PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi.nii.gz -Tmean $PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_tmean.nii.gz
      
      # remove garbage
      rm -r $WRK_DIR/*padded.nii.gz $WRK_DIR/*corrected.nii.gz $PERF_DIR/*padded.nii.gz $PERF_DIR/*corrected.nii.gz
   fi
} 

function despike() {
   if [ -f $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-despike_bold.nii.gz ]; then
      echo "Despiking already done...skipping to next task"
   else
      echo "Despiking data..."
      # remove outliers from time courses
      3dDespike -overwrite -q -nomask -prefix $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-despike_bold.nii.gz $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_volreg_bold_topup.nii.gz
      3dDespike -overwrite -q -nomask -prefix $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-despike_bold.nii.gz  $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_volreg_bold_topup.nii.gz
      3dDespike -overwrite -q -nomask -prefix $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_desc-despike_bold.nii.gz $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_volreg_bold_topup.nii.gz
   fi
}
    
function slice_time_correction() {
   if [ -f $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-tshift_bold.nii.gz ]; then
      echo "Timing correction already done...skipping to next task"
   else
      echo "Correcting slice timing assuming Siemens interleaved acquisition scheme..."
      # use TR to do slice-time correction for sequential + time slice acquisition
      3dTshift -heptic -TR $TR_secs -tpattern seqplus \
         -prefix $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-tshift_bold.nii.gz $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-despike_bold.nii.gz
         
      3dTshift -heptic -TR $TR_secs -tpattern seqplus \
         -prefix $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-tshift_bold.nii.gz $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-despike_bold.nii.gz
      
      3dTshift -heptic -TR $TR_secs -tpattern seqplus \
         -prefix $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_desc-tshift_bold.nii.gz $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_desc-despike_bold.nii.gz
   fi
}
    
function mask_M0() {
   if [ -f $PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_brain_mask.nii.gz ]; then
      echo "Masking already done...skipping to next task"
   else
      echo "Masking functional image..."
      # skullstrip M0
      N4BiasFieldCorrection -d 3 -i $PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_tmean.nii.gz -o $PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_N4.nii.gz
      bet $PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_N4.nii.gz $PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_brain.nii.gz -m
   fi
}

function coregister_runs() {
   if [ -f $WRK_DIR/${SUBJ}_run2toanat.nii.gz ]; then
      echo "Runs already coregistered...skipping to next task"
   else

      # rm $WRK_DIR/${SUBJ}_*tom0_*
      fslmaths $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-despike_bold.nii.gz -Tmean $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-despike_bold_tmean.nii.gz
      fslmaths $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-despike_bold.nii.gz -Tmean $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-despike_bold_tmean.nii.gz
      fslmaths $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_desc-despike_bold.nii.gz -Tmean $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_desc-despike_bold_tmean.nii.gz

      echo "Coregistering runs with rigid body registration..."

      FIXED=$PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_brain.nii.gz

      MOVING=$WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-despike_bold_tmean.nii.gz
      # moving task-bh run-01 tmean, fixed image structural n4 corrected
      antsRegistration --verbose 1 --dimensionality 3 --float 0 \
         --interpolation Linear --use-histogram-matching 1 --winsorize-image-intensities [0.005,0.995] \
         --initial-moving-transform [$FIXED, $MOVING,1] \
         --transform Rigid[0.1] \
         --metric MI[$FIXED,$MOVING,1,32,Regular,0.3] \
         --convergence 500x250x100 --shrink-factors 4x2x1 \
         --smoothing-sigmas 2x1x0vox \
         --output [$WRK_DIR/${SUBJ}_run1toanat_, $WRK_DIR/${SUBJ}_run1toanat.nii.gz]

      MOVING=$WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-despike_bold_tmean.nii.gz
      # moving rest tmean, fixed image structural n4 corrected
      antsRegistration --verbose 1 --dimensionality 3 --float 0 \
         --interpolation Linear --use-histogram-matching 1 --winsorize-image-intensities [0.005,0.995] \
         --initial-moving-transform [$FIXED, $MOVING,1] \
         --transform Rigid[0.1] \
         --metric MI[$FIXED,$MOVING,1,32,Regular,0.3] \
         --convergence 500x250x100 --shrink-factors 4x2x1 \
         --smoothing-sigmas 2x1x0vox \
         --output [$WRK_DIR/${SUBJ}_tasktoanat_, $WRK_DIR/${SUBJ}_tasktoanat.nii.gz]

      MOVING=$WRK_DIR/${SUBJ}_task-bh_run-02_dexi_desc-despike_bold_tmean.nii.gz
      # moving task-bh run-02 tmean, fixed image structural n4 corrected
      antsRegistration --verbose 1 --dimensionality 3 --float 0 \
         --interpolation Linear --use-histogram-matching 1 --winsorize-image-intensities [0.005,0.995] \
         --initial-moving-transform [$FIXED, $MOVING,1] \
         --transform Rigid[0.1] \
         --metric MI[$FIXED,$MOVING,1,32,Regular,0.3] \
         --convergence 500x250x100 --shrink-factors 4x2x1 \
         --smoothing-sigmas 2x1x0vox \
         --output [$WRK_DIR/${SUBJ}_run2toanat_, $WRK_DIR/${SUBJ}_run2toanat.nii.gz]
      fi
}  

function filter_data() {
   if [ -f $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-filtered_bold.nii.gz ]; then
      echo "Filtering already done...skipping to next task"
   else
      # bandpass filter
      3dTproject -overwrite -input $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-despike_bold.nii.gz \
         -mask $PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_brain_mask.nii.gz -prefix $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-filtered_bold.nii.gz -polort 2 -TR $TR_secs -bandpass $fbot $ftop
      3dTproject -overwrite -input $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-despike_bold.nii.gz  \
         -mask $PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_brain_mask.nii.gz -prefix $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-filtered_bold.nii.gz -polort 2 -TR $TR_secs -bandpass $fbot $ftop
      3dTproject -overwrite -input $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_desc-despike_bold.nii.gz \
         -mask $PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_brain_mask.nii.gz -prefix $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_desc-filtered_bold.nii.gz -polort 2 -TR $TR_secs -bandpass $fbot $ftop
   fi
}

function get_csf_timecourse() {
   if [ -f $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-csf_timecourse ]; then
      echo "CSF timecourses already extracted...skipping to next task"
   else
      echo "Extracting CSF and vascular timecourses..."     
      # task-bh run-01
      TFORMS="-t [ $WRK_DIR/${SUBJ}_run1toanat_0GenericAffine.mat , 1 ] -t [ $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_0GenericAffine.mat , 1 ] -t $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1InverseWarp.nii.gz"
      # transform masks from template to functional space
      antsApplyTransforms -d 3 -i $VEN_MASK \
         -r $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-despike_bold_tmean.nii.gz -o $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_csf_mask.nii.gz -n NearestNeighbor $TFORMS
      fslmaths $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_csf_mask.nii.gz -thr 0.25 -bin -mas $func_mask $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_csf_mask.nii.gz
      
      # task-bh run-02
      TFORMS="-t [ $WRK_DIR/${SUBJ}_run2toanat_0GenericAffine.mat , 1 ] -t [ $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_0GenericAffine.mat , 1 ] -t $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1InverseWarp.nii.gz"
      # transform masks from template to functional space
      antsApplyTransforms -d 3 -i $VEN_MASK \
         -r $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_desc-despike_bold_tmean.nii.gz -o $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_csf_mask.nii.gz -n NearestNeighbor $TFORMS
      fslmaths $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_csf_mask.nii.gz -thr 0.25 -bin -mas $func_mask $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_csf_mask.nii.gz
      
      # task- rest - glove - rest
      TFORMS="-t [ $WRK_DIR/${SUBJ}_tasktoanat_0GenericAffine.mat , 1 ] -t [ $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_0GenericAffine.mat , 1 ] -t $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1InverseWarp.nii.gz"
      # transform masks from template to functional space
      antsApplyTransforms -d 3 -i $VEN_MASK \
         -r $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-despike_bold_tmean.nii.gz -o $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_csf_mask.nii.gz -n NearestNeighbor $TFORMS
      fslmaths $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_csf_mask.nii.gz -thr 0.25 -bin -mas $func_mask $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_csf_mask.nii.gz

      #extract time series from CSF mask
      fslmeants -i $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-despike_bold.nii.gz -o $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_desc-csf_timecourse -m $WRK_DIR/${SUBJ}_task-bh_run-01_dexi_csf_mask.nii.gz
      fslmeants -i $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_desc-despike_bold.nii.gz -o $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_desc-csf_timecourse -m $WRK_DIR/${SUBJ}_task-bh_run-02_dexi_csf_mask.nii.gz
      fslmeants -i $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-despike_bold.nii.gz -o $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-csf_timecourse -m $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_csf_mask.nii.gz
   fi
}

#copiato, da aggiustare
function regress_data() {
   if [ -f $WRK_DIR/${SUBJ}_desc-smooth_bold.nii.gz ]; then
      echo "Regression already done...skipping to next task"
   else
      echo "Regressing physiology from BOLD images"

      # awk '{ print $2, $3, $4, $5, $6, $7 }' $WRK_DIR/${SUBJ}_volreg.1D > $WRK_DIR/${SUBJ}_motion.1D

      rm $WRK_DIR/${SUBJ}_nuisance.1D

      # create combined nuisance file
      pr -mts $WRK_DIR/${SUBJ}_motion.1D $WRK_DIR/tmp_signal_GBS > $WRK_DIR/${SUBJ}_nuisance.1D
      # pr -mts $WRK_DIR/${SUBJ}_motion.1D $WRK_DIR/tmp_filtered_signal_CSF $PHYS_DIR/$SUBJ/${SUBJ}_CO2.txt > $WRK_DIR/${SUBJ}_nuisance.1D

      # nuisance regression and filtering
      3dTproject -overwrite -input $WRK_DIR/${SUBJ}_desc-despike_bold.nii.gz -prefix $WRK_DIR/${SUBJ}_desc-motionbp_bold.nii.gz \
         -ort $WRK_DIR/${SUBJ}_motion.1D -polort 2 -mask $PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_brain_mask.nii.gz -TR $TR_secs -bandpass $fbot $ftop

      3dBlurInMask -overwrite -input $WRK_DIR/${SUBJ}_desc-motionbp_bold.nii.gz -fwhm $FWHM -mask $func_mask -prefix $WRK_DIR/${SUBJ}_desc-smooth_bold.nii.gz
   fi
}

function final_images() {
   if [ -f $WRK_DIR/${SUBJ}_dexi_run-02_task-rest_desc-preproc.nii.gz ]; then
      echo "Images already split...skipping to next task"
   else
      echo "Splitting images..."
      fslroi $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-filtered_bold.nii.gz $WRK_DIR/${SUBJ}_task-rest_run-01_dexi_desc-preproc_bold.nii.gz 0 103
      fslroi $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-filtered_bold.nii.gz $WRK_DIR/${SUBJ}_task-glove_dexi_desc-preproc_bold.nii.gz 112 196
      fslroi $WRK_DIR/${SUBJ}_dexi_REST_TASK_REST_desc-filtered_bold.nii.gz $WRK_DIR/${SUBJ}_task-rest_run-02_dexi_desc-preproc_bold.nii.gz 308 102
   fi
}

function test_data_quality() {
   if [ -d "$WRK_DIR/${SUBJ}_desc-filtered_bold.ica" ]; then
      echo "ICA already done...skipping to next task"
   else
      # optional, call melodic to see if data were acquired properly
      # if no good components are present the subject is either dead or unable to think (both cases are dangerous and/or wrong)  
      melodic -i $WRK_DIR/${SUBJ}_dexi_task-glove_desc-preproc_bold.nii.gz -m $func_mask -d 10 --report --bgimage=$PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_N4.nii.gz --approach=symm
   fi
}

# constants
TR_secs=4.4
FWHM=4.5
fbot=0.01
ftop=0.1

fortune
mapfile -t SCANS < subjects.txt # read subjects from text file

# SUBJ=$1
for SUBJ in ${SCANS[@]}; do
   sleep 2
   cowsay Processing: $SUBJ
   # folder definitions
   WRK_DIR="$PROC_DIR/$SUBJ/func"
   PERF_DIR="$PROC_DIR/$SUBJ/perf"
   mkdir -p $WRK_DIR
   mkdir -p $PERF_DIR
   mkdir -p $REG_DIR/func
   cd $WRK_DIR

   ## set filenames
   func_mask="$PERF_DIR/${SUBJ}_acq-M0_dir-AP_dexi_brain_mask.nii.gz"

   motion_correction
   run_topup
   despike
   # ## slice_time_correction
   mask_M0
   filter_data
   coregister_runs
   get_csf_timecourse
   ## regress_data
   final_images
   ## test_data_quality
done