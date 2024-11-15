#!/bin/bash 
source ./project.sh

: '
script for subject FEAT preparation
remember to prepare a first design file using the FEAT GUI
edit the txtfile field with the design file path
N.B. the script does not use ANTs transformations
requirements: fsl
Davide Di Censo @ITAB 2024
'

### set up variables ###
mapfile -t SCANS < subjects.txt #read subjects from textfile
txtfile="$ROOT_DIR/FEAT/design.fsf"

for SUBJ in ${SCANS[@]}; do
  if [ -d "$ROOT_DIR/FEAT/${SUBJ}/" ]; then
    echo "FEAT already done...skipping to next task"
  else
    sleep 2
    cowsay Processing: $SUBJ
    echo "writing design file for ${SUBJ}..."

    cp $txtfile $PROC_DIR/$SUBJ/func/design.fsf
    chmod 775 $PROC_DIR/$SUBJ/func/design.fsf
    
    # edit design file with subjects specific fields
    sed -i "33s@.*@set fmri(outputdir) "$ROOT_DIR/FEAT/${SUBJ}/"@g" $PROC_DIR/$SUBJ/func/design.fsf
    sed -i "276s@.*@set feat_files(1) "$PROC_DIR/$SUBJ/func/${SUBJ}_task-glove_dexi_desc-preproc_bold_scaled"@g" $PROC_DIR/$SUBJ/func/design.fsf
    sed -i "282s@.*@set highres_files(1) "$PROC_DIR/$SUBJ/anat/${SUBJ}_inv-02_MP2RAGE_brain"@g" $PROC_DIR/$SUBJ/func/design.fsf
    
    # scaling filtered image using the bold despike tmean
    fslmaths $PROC_DIR/$SUBJ/func/${SUBJ}_dexi_REST_TASK_REST_desc-despike_bold_tmean.nii.gz -Tmean $PROC_DIR/$SUBJ/func/${SUBJ}_task-glove_dexi_desc-preproc_bold_tmean.nii.gz
    fslmaths $PROC_DIR/$SUBJ/func/${SUBJ}_task-glove_dexi_desc-preproc_bold.nii.gz -add $PROC_DIR/$SUBJ/func/${SUBJ}_task-glove_dexi_desc-preproc_bold_tmean.nii.gz $PROC_DIR/$SUBJ/func/${SUBJ}_task-glove_dexi_desc-preproc_bold_scaled.nii.gz

    # start FEAT analysis 
    echo "===> Starting FEAT for ${SUBJ} <==="
    feat $PROC_DIR/$SUBJ/func/design.fsf
    echo "done"
  fi
done