#!/bin/bash
source project.sh

: '
Preprocessing wrapper script for SANDI dwi analysis
requirements: fsl, AFNI, ANTs, mrtrix3, MATLAB
SANDI toolbox (https://github.com/palombom/SANDI-Matlab-Toolbox-Latest-Release)
Davide Di Censo, based on the scripts developed by Alessandra Stella Caporale and Marco Palombo @ITAB 2024
'

##Extract brain mask
function brain_mask() {
  if [ -f $WRK_DIR/${SUBJ}_run-01_acq-B0_dir-AP.nii.gz ]; then
    echo "Brain extraction already done...skipping to next task"
  else
    echo "Running brain extraction of AP B0..."
    #extract first volume of dwi images as B0_AP
    fslroi $ROOT_DIR/$SUBJ/dwi/${SUBJ}_run-01_dwi.nii.gz $WRK_DIR/${SUBJ}_run-01_acq-B0_dir-AP.nii.gz 0 1
    fslroi $ROOT_DIR/$SUBJ/dwi/${SUBJ}_run-02_dwi.nii.gz $WRK_DIR/${SUBJ}_run-02_acq-B0_dir-AP.nii.gz 0 1
  fi
}

function denoise() {
  if [ -f $WRK_DIR/${SUBJ}_run-01_dwi_denoised.nii.gz ]; then
    echo "Denoising already done...skipping to next task"
  else
    echo "Denoising..."

    dwiextract -fslgrad $BVECS $BVALS -shells 0,500,1000,2000 $ROOT_DIR/$SUBJ/dwi/${SUBJ}_run-01_dwi.nii.gz $WRK_DIR/${SUBJ}_run-01_dwi_extracted.nii.gz
    dwiextract -fslgrad $BVECS $BVALS -shells 0,500,1000,2000 $ROOT_DIR/$SUBJ/dwi/${SUBJ}_run-02_dwi.nii.gz $WRK_DIR/${SUBJ}_run-02_dwi_extracted.nii.gz
    dwidenoise -force $ROOT_DIR/$SUBJ/dwi/${SUBJ}_run-01_dwi.nii.gz $WRK_DIR/${SUBJ}_run-01_dwi_denoised.nii.gz
    dwidenoise -force $ROOT_DIR/$SUBJ/dwi/${SUBJ}_run-02_dwi.nii.gz $WRK_DIR/${SUBJ}_run-02_dwi_denoised.nii.gz
    # Noise map b values < 3000
    dwidenoise -force -noise $WRK_DIR/${SUBJ}_run-01_dwi_noisemap.nii.gz $WRK_DIR/${SUBJ}_run-01_dwi_extracted.nii.gz $WRK_DIR/${SUBJ}_run-01_dwi_extracted_denoised.nii.gz
    dwidenoise -force -noise $WRK_DIR/${SUBJ}_run-02_dwi_noisemap.nii.gz $WRK_DIR/${SUBJ}_run-02_dwi_extracted.nii.gz $WRK_DIR/${SUBJ}_run-02_dwi_extracted_denoised.nii.gz

    rm $WRK_DIR/${SUBJ}_run-01_dwi_extracted_denoised.nii.gz $WRK_DIR/${SUBJ}_run-01_dwi_extracted.nii.gz $WRK_DIR/${SUBJ}_run-02_dwi_extracted_denoised.nii.gz $WRK_DIR/${SUBJ}_run-02_dwi_extracted.nii.gz
  fi
}

##Gibbs Ringing Correction
function gibbs_correction() {
  if [ -f $WRK_DIR/${SUBJ}_run-01_dwi_denoised_derung.nii.gz ]; then
    echo "Gibbs Ringing Correction already done...skipping to next task"
  else
    echo "Running Gibbs Ringing Correction..."
    mrdegibbs -force $WRK_DIR/${SUBJ}_run-01_dwi_denoised.nii.gz $WRK_DIR/${SUBJ}_run-01_dwi_denoised_derung.nii.gz
    mrdegibbs -force $WRK_DIR/${SUBJ}_run-02_dwi_denoised.nii.gz $WRK_DIR/${SUBJ}_run-02_dwi_denoised_derung.nii.gz
  fi
}

##Topup
function run_topup() {
  if [ -f $WRK_DIR/topup/topup_fieldcoef.nii.gz ]; then
    echo "Topup already done...skipping to next task"
  else
    echo "Running Topup..."
    
    fslmaths $B0_PA -Tmean $WRK_DIR/topup/${SUBJ}_run-01_acq-B0_dir-PA.nii.gz
    fslmerge -t $WRK_DIR/topup/${SUBJ}_run-01_acq-B0_dir-AP_PA.nii.gz $WRK_DIR/${SUBJ}_run-01_acq-B0_dir-AP.nii.gz $WRK_DIR/topup/${SUBJ}_run-01_acq-B0_dir-PA.nii.gz
    topup --imain=$WRK_DIR/topup/${SUBJ}_run-01_acq-B0_dir-AP_PA.nii.gz --datain=$SCRIPT_DIR/dwi_acqparams.txt --config=b02b0.cnf --out=$WRK_DIR/topup/topup --iout=$WRK_DIR/${SUBJ}_my_hifi_b0 
  fi
}

##Eddy 
function run_eddy() {
  if [ -f $WRK_DIR/eddy/${SUBJ}_run-01_dwi_denoised_derung_eddy_dwi.nii.gz ]; then
    echo "Eddy correction already done...skipping to next task"
  else
    echo "Running eddy correction..."
    #create index file
    output="$(fslval $ROOT_DIR/$SUBJ/dwi/${SUBJ}_run-01_dwi.nii.gz dim4)" 
    indx=""
    for i in `seq 1 $output`; do indx="$indx 1"; done 
    echo $indx > $WRK_DIR/eddy/index.txt
    cd $WRK_DIR/eddy/
    bet $WRK_DIR/${SUBJ}_run-01_acq-B0_dir-AP.nii.gz $WRK_DIR/eddy/${SUBJ}_run-01_acq-B0_brain.nii.gz -R -f 0.40 -g 0 -n -m #0.15
    mv $WRK_DIR/eddy/${SUBJ}_run-01_acq-B0_brain_mask.nii.gz $WRK_DIR/eddy/${SUBJ}_run-01_acq-B0_mask.nii.gz
    bet $WRK_DIR/${SUBJ}_run-02_acq-B0_dir-AP.nii.gz $WRK_DIR/eddy/${SUBJ}_run-02_acq-B0_brain.nii.gz -R -f 0.40 -g 0 -n -m #0.15
    mv $WRK_DIR/eddy/${SUBJ}_run-02_acq-B0_brain_mask.nii.gz $WRK_DIR/eddy/${SUBJ}_run-02_acq-B0_mask.nii.gz

    eddy_cuda --imain=$WRK_DIR/${SUBJ}_run-01_dwi_denoised_derung.nii.gz --mask=${SUBJ}_run-01_acq-B0_mask.nii.gz --acqp=$SCRIPT_DIR/dwi_acqparams.txt --index=$WRK_DIR/eddy/index.txt --bvecs=$BVECS --bvals=$BVALS --topup=$WRK_DIR/topup/topup --repol --out=$WRK_DIR/eddy/${SUBJ}_run-01_dwi_denoised_derung_eddy_dwi --data_is_shelled=1
    eddy_cuda --imain=$WRK_DIR/${SUBJ}_run-02_dwi_denoised_derung.nii.gz --mask=${SUBJ}_run-02_acq-B0_mask.nii.gz --acqp=$SCRIPT_DIR/dwi_acqparams.txt --index=$WRK_DIR/eddy/index.txt --bvecs=$BVECS --bvals=$BVALS --topup=$WRK_DIR/topup/topup --repol --out=$WRK_DIR/eddy/${SUBJ}_run-02_dwi_denoised_derung_eddy_dwi --data_is_shelled=1
    cd ..
  fi
}

function coregister_runs() {
  if [ -f $WRK_DIR/${SUBJ}_run1toanat.nii.gz ]; then
    echo "Runs already coregistered...skipping to next task"
  else
    echo "Coregistering runs to reference structural image with rigid body registration..."
    bet $WRK_DIR/eddy/${SUBJ}_run-01_dwi_denoised_derung_eddy_dwi.nii.gz $WRK_DIR/${SUBJ}_run-01_acq-B0_brain_corr.nii.gz -R -f 0.40 -g 0 -n -m #0.15
    bet $WRK_DIR/eddy/${SUBJ}_run-02_dwi_denoised_derung_eddy_dwi.nii.gz $WRK_DIR/${SUBJ}_run-02_acq-B0_brain_corr.nii.gz -R -f 0.40 -g 0 -n -m #0.15
    FIXED=$PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_brain.nii.gz
    MOVING=$WRK_DIR/${SUBJ}_run-01_acq-B0_brain_corr.nii.gz

    antsRegistration --verbose 1 --dimensionality 3 --float 0 \
      --interpolation Linear --use-histogram-matching 1 --winsorize-image-intensities [0.005,0.995] \
      --initial-moving-transform [$FIXED, $MOVING,1] \
      --transform Rigid[0.1] \
      --metric MI[$FIXED,$MOVING,1,32,Regular,0.3] \
      --convergence 500x250x100 --shrink-factors 4x2x1 \
      --smoothing-sigmas 2x1x0vox \
      --output [$WRK_DIR/${SUBJ}_run1toanat_, $WRK_DIR/${SUBJ}_run1toanat.nii.gz]

    MOVING=$WRK_DIR/${SUBJ}_run-02_acq-B0_brain_corr.nii.gz

    # moving image b0 tmean, fixed image structural n4 corrected
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

function organise_data(){
  if [ -f $WRK_DIR/SANDI_input/${SUBJ}_run-02_data_dwi.bvec ]; then
    echo "Data already organised...skipping to next task"
  else
    cp $WRK_DIR/eddy/${SUBJ}_run-01_dwi_denoised_derung_eddy_dwi.nii.gz $WRK_DIR/SANDI_input/${SUBJ}_run-01_data_dwi.nii.gz
    cp $WRK_DIR/${SUBJ}_run-01_dwi_noisemap.nii.gz $WRK_DIR/SANDI_input/${SUBJ}_run-01_data_noisemap.nii.gz
    cp $WRK_DIR/${SUBJ}_run-01_acq-B0_brain_corr_mask.nii.gz $WRK_DIR/SANDI_input/${SUBJ}_run-01_data_mask.nii.gz
    cp $WRK_DIR/eddy/${SUBJ}_run-01_dwi_denoised_derung_eddy_dwi.eddy_rotated_bvecs $WRK_DIR/SANDI_input/${SUBJ}_run-01_data_dwi.bvec

    cp $WRK_DIR/eddy/${SUBJ}_run-02_dwi_denoised_derung_eddy_dwi.nii.gz $WRK_DIR/SANDI_input/${SUBJ}_run-02_data_dwi.nii.gz
    cp $WRK_DIR/${SUBJ}_run-02_dwi_noisemap.nii.gz $WRK_DIR/SANDI_input/${SUBJ}_run-02_data_noisemap.nii.gz
    cp $WRK_DIR/${SUBJ}_run-02_acq-B0_brain_corr_mask.nii.gz $WRK_DIR/SANDI_input/${SUBJ}_run-02_data_mask.nii.gz
    cp $WRK_DIR/eddy/${SUBJ}_run-02_dwi_denoised_derung_eddy_dwi.eddy_rotated_bvecs $WRK_DIR/SANDI_input/${SUBJ}_run-02_data_dwi.bvec

    cp $BVALS $WRK_DIR/SANDI_input/data_dwi.bval
  fi
}

function do_SANDI_analysis() {  
  if [ -f $WRK_DIR/SANDI_Output/${SUBJ}_run-01_SANDI-fit_Rsoma.nii.gz ]; then
    echo "SANDI analysis already done...skipping to next task"
  else
    MAPS=('De' 'Din' 'Din_Filtered' 'fextra' 'fneurite' 'fsoma' 'Rsoma' 'Rsoma_Filtered')

    matlab -nodisplay -r "cd('$SCRIPT_DIR'); SANDI_batch_analysis('$WRK_DIR',44.26,21.78,[],'$SUBJ','run-01'); exit"
    for MAP in ${MAPS[@]}; do
      mv $WRK_DIR/SANDI_Output/SANDI-fit_${MAP}.nii.gz $WRK_DIR/SANDI_Output/${SUBJ}_run-01_SANDI-fit_${MAP}.nii.gz
    done 

    matlab -nodisplay -r "cd('$SCRIPT_DIR'); SANDI_batch_analysis('$WRK_DIR',44.26,21.78,[],'$SUBJ','run-02'); exit"
    for MAP in ${MAPS[@]}; do
      mv $WRK_DIR/SANDI_Output/SANDI-fit_${MAP}.nii.gz $WRK_DIR/SANDI_Output/${SUBJ}_run-02_SANDI-fit_${MAP}.nii.gz
    done
  fi
}

function do_dti(){
  if [ -f $WRK_DIR/DTI/${SUBJ}_run-01_dwi_preproc.nii.gz ]; then
    echo "DTI fit already done...skipping to next task"
  else

    dwiextract -fslgrad $WRK_DIR/eddy/${SUBJ}_run-01_dwi_denoised_derung_eddy_dwi.eddy_rotated_bvecs $BVALS -shells 0,500,1000 -export_grad_fsl $WRK_DIR/DTI/${SUBJ}_run-01_dwi_denoised_derung_eddy_dwi.bvecs $WRK_DIR/DTI/${SUBJ}_run-01_dwi_denoised_derung_eddy_dwi.bval $WRK_DIR/eddy/${SUBJ}_run-01_dwi_denoised_derung_eddy_dwi.nii.gz $WRK_DIR/DTI/${SUBJ}_run-01_dwi_preproc.nii.gz
    
    dwiextract -fslgrad $WRK_DIR/eddy/${SUBJ}_run-02_dwi_denoised_derung_eddy_dwi.eddy_rotated_bvecs $BVALS -shells 0,500,1000 -export_grad_fsl $WRK_DIR/DTI/${SUBJ}_run-02_dwi_denoised_derung_eddy_dwi.bvecs $WRK_DIR/DTI/${SUBJ}_run-02_dwi_denoised_derung_eddy_dwi.bval $WRK_DIR/eddy/${SUBJ}_run-02_dwi_denoised_derung_eddy_dwi.nii.gz $WRK_DIR/DTI/${SUBJ}_run-02_dwi_preproc.nii.gz  

    dtifit -k $WRK_DIR/DTI/${SUBJ}_run-01_dwi_preproc.nii.gz -o $WRK_DIR/DTI/${SUBJ}_run-01_dti \
      -m $WRK_DIR/${SUBJ}_run-01_acq-B0_brain_corr_mask.nii.gz \
      -r $WRK_DIR/DTI/${SUBJ}_run-01_dwi_denoised_derung_eddy_dwi.bvecs \
      -b $WRK_DIR/DTI/${SUBJ}_run-01_dwi_denoised_derung_eddy_dwi.bval -V

    fslmaths $WRK_DIR/DTI/${SUBJ}_run-01_dti_L2.nii.gz -add $WRK_DIR/DTI/${SUBJ}_run-01_dti_L3.nii.gz -div 2 $WRK_DIR/DTI/${SUBJ}_run-01_dti_RD.nii.gz

    dtifit -k $WRK_DIR/DTI/${SUBJ}_run-02_dwi_preproc.nii.gz -o $WRK_DIR/DTI/${SUBJ}_run-02_dti \
      -m $WRK_DIR/${SUBJ}_run-02_acq-B0_brain_corr_mask.nii.gz \
      -r $WRK_DIR/DTI/${SUBJ}_run-02_dwi_denoised_derung_eddy_dwi.bvecs \
      -b $WRK_DIR/DTI/${SUBJ}_run-02_dwi_denoised_derung_eddy_dwi.bval -V

    fslmaths $WRK_DIR/DTI/${SUBJ}_run-02_dti_L2.nii.gz -add $WRK_DIR/DTI/${SUBJ}_run-02_dti_L3.nii.gz -div 2 $WRK_DIR/DTI/${SUBJ}_run-02_dti_RD.nii.gz
  fi
}

function warp_maps() {
  if [ -f $WRK_DIR/${SUBJ}_run-01_labels.nii.gz ]; then
    echo "warping already done...skipping to next task"
  else
    REF=$WRK_DIR/${SUBJ}_run-01_acq-B0_brain_corr.nii.gz
    SANDI_MAPS=('De' 'Din' 'Din_Filtered' 'fextra' 'fneurite' 'fsoma' 'Rsoma' 'Rsoma_Filtered')
    DTI_MAPS=('FA' 'RD' 'L1' 'MD')

    TMFS="-t $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1Warp.nii.gz -t $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_0GenericAffine.mat"
    INV_TMFS="-t [ $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_0GenericAffine.mat , 1 ] -t $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1InverseWarp.nii.gz"

    for MAP in ${SANDI_MAPS[@]}; do
      # warp images to MNI space
      antsApplyTransforms -d 3 -e 3 -i $WRK_DIR/SANDI_Output/${SUBJ}_run-01_SANDI-fit_${MAP}.nii.gz -r $ATLAS -o $REG_DIR/SANDI/${SUBJ}_run-01_SANDI-fit_${MAP}.nii.gz $TMFS -t $WRK_DIR/${SUBJ}_run1toanat_0GenericAffine.mat
      antsApplyTransforms -d 3 -e 3 -i $WRK_DIR/SANDI_Output/${SUBJ}_run-02_SANDI-fit_${MAP}.nii.gz -r $ATLAS -o $REG_DIR/SANDI/${SUBJ}_run-02_SANDI-fit_${MAP}.nii.gz $TMFS -t $WRK_DIR/${SUBJ}_run2toanat_0GenericAffine.mat

      # calculate map differences
      fslmaths $REG_DIR/SANDI/${SUBJ}_run-02_SANDI-fit_${MAP}.nii.gz -sub $REG_DIR/SANDI/${SUBJ}_run-01_SANDI-fit_${MAP}.nii.gz $REG_DIR/SANDI/${SUBJ}_SANDI-fit_${MAP}_differences.nii.gz
    done

    for MAP in ${DTI_MAPS[@]}; do
      # warp images to MNI space
      antsApplyTransforms -d 3 -e 3 -i $WRK_DIR/DTI/${SUBJ}_run-01_dti_${MAP}.nii.gz -r $ATLAS -o $REG_DIR/DTI/${SUBJ}_run-01_dti_${MAP}.nii.gz $TMFS -t $WRK_DIR/${SUBJ}_run1toanat_0GenericAffine.mat 
      antsApplyTransforms -d 3 -e 3 -i $WRK_DIR/DTI/${SUBJ}_run-02_dti_${MAP}.nii.gz -r $ATLAS -o $REG_DIR/DTI/${SUBJ}_run-02_dti_${MAP}.nii.gz $TMFS -t $WRK_DIR/${SUBJ}_run2toanat_0GenericAffine.mat

      # calculate map differences
      fslmaths $REG_DIR/DTI/${SUBJ}_run-02_dti_${MAP}.nii.gz -sub $REG_DIR/DTI/${SUBJ}_run-01_dti_${MAP}.nii.gz $REG_DIR/DTI/${SUBJ}_dti_${MAP}_differences.nii.gz

    done

    antsApplyTransforms -d 3 -i $LABELS -r $WRK_DIR/${SUBJ}_run-01_acq-B0_brain_corr.nii.gz -o $WRK_DIR/${SUBJ}_run-01_labels.nii.gz -n Multilabel -t [ $WRK_DIR/${SUBJ}_run1toanat_0GenericAffine.mat , 1 ] $INV_TMFS
    antsApplyTransforms -d 3 -i $LABELS -r $WRK_DIR/${SUBJ}_run-02_acq-B0_brain_corr.nii.gz -o $WRK_DIR/${SUBJ}_run-02_labels.nii.gz -n Multilabel -t [ $WRK_DIR/${SUBJ}_run2toanat_0GenericAffine.mat , 1 ] $INV_TMFS
  fi
}

fortune

mapfile -t SCANS < subjects.txt #read subjects from textfile
# FWHM=4.5
printf "0 1 0 0.05\n0 -1 0 0.05" > $SCRIPT_DIR/dwi_acqparams.txt

# SUBJ=$1
for SUBJ in ${SCANS[@]}; do
  sleep 2
  cowsay -f vader-koala Processing: $SUBJ
  # folder definitions
  WRK_DIR="$PROC_DIR/$SUBJ/dwi"
  mkdir -p $WRK_DIR/topup/
  mkdir -p $WRK_DIR/eddy/
  mkdir -p $WRK_DIR/DTI/
  mkdir -p $WRK_DIR/SANDI_input/
  mkdir -p $REG_DIR/SANDI
  mkdir -p $REG_DIR/DTI
  cd $WRK_DIR/

  B0_PA="$ROOT_DIR/${SUBJ}/fmap/${SUBJ}_acq-B0_dir-PA_dwi.nii.gz"
  BVALS="$ROOT_DIR/${SUBJ}/dwi/${SUBJ}_run-01_dwi.bval"
  BVECS="$ROOT_DIR/${SUBJ}/dwi/${SUBJ}_run-01_dwi.bvec"

  brain_mask
  denoise
  gibbs_correction
  run_topup
  run_eddy
  coregister_runs
  organise_data
  do_SANDI_analysis
  do_dti
  warp_maps
done