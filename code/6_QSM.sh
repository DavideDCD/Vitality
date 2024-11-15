#!/bin/bash
source project.sh

: '
Wrapper script for QSM preprocessing,
requirements: fsl, MATLAB
Davide Di Censo, based on the scripts developed by Emma Biondetti @ITAB 2024
'

function Romeo() {
  if [ -d "$WRK_DIR/QSM/romeo_unw/" ]; then
  	echo "skipping to next task"
  else
    echo "merging phase and magnitude images"
    fslmerge -t $WRK_DIR/QSM/Magnitude/mag.nii.gz $GRE_MAG1 $GRE_MAG2 $GRE_MAG3 $GRE_MAG4 $GRE_MAG5
    gunzip $WRK_DIR/QSM/Magnitude/mag.nii.gz
    fslmerge -t $WRK_DIR/QSM/Phase/phase.nii.gz $GRE_PHASE1 $GRE_PHASE2 $GRE_PHASE3 $GRE_PHASE4 $GRE_PHASE5
    fslmaths $WRK_DIR/QSM/Phase/phase.nii.gz -div 1000 $WRK_DIR/QSM/Phase/phase_rad.nii.gz
    gunzip $WRK_DIR/QSM/Phase/phase_rad.nii.gz
    rm $WRK_DIR/QSM/Phase/phase.nii.gz

    # 2. Running ROMEO
    echo "O Romeo, Romeo, wherefore art thou Romeo?"
    $ROMEO -p $WRK_DIR/QSM/Phase/phase_rad.nii -m $WRK_DIR/QSM/Magnitude/mag.nii -t [7.62,12.78,17.94,23.10,28.26] -o $WRK_DIR/QSM/romeo_unw --write-phase-offsets -B --phase-offset-correction on
    gzip $WRK_DIR/QSM/romeo_unw/*nii

    # 3. Removing temporary files
    echo "Cleaning garbage"
    rm $WRK_DIR/QSM/Magnitude/mag.nii
    rm $WRK_DIR/QSM/Phase/phase_rad.nii
  fi
}

function QSM() {
  if [ -f "$WRK_DIR/QSM/${SUBJ}_local_field_map_VSHARP_Hz.nii.gz" ]; then
  	echo "skipping to next task"
  else
    echo "QSM analysis"
    matlab -nodisplay -r "cd('$SCRIPT_DIR'); QSM_proc('$WRK_DIR'); exit" 
    mv $WRK_DIR/QSM/QSM_VSHARP_ppm.nii.gz $WRK_DIR/QSM/${SUBJ}_QSM_VSHARP_ppm.nii.gz
    mv $WRK_DIR/QSM/local_field_map_VSHARP_Hz.nii.gz $WRK_DIR/QSM/${SUBJ}_local_field_map_VSHARP_Hz.nii.gz
  fi
}

fortune
mapfile -t SCANS < subjects.txt

# SUBJ=$1
for SUBJ in ${SCANS[@]}; do
  sleep 2
  cowsay -f stegosaurus  Processing Subject $SUBJ
  # define commands
  ROMEO="/storage/emma/mritools_Linux_3.5.0/bin/romeo"
  # define files and folders
  WRK_DIR=$PROC_DIR/$SUBJ/anat

  if [ -f "$ROOT_DIR/$SUBJ/anat/${SUBJ}_echo-01_part-mag_MEGRE.nii.gz" ]; then
    # 0. Moving magnitude and phase images to dedicated subfolders
    mkdir -p $WRK_DIR/QSM/Magnitude
    mkdir -p $WRK_DIR/QSM/Phase
    cp $ROOT_DIR/$SUBJ/anat/*MEGRE*.nii.gz $WRK_DIR/QSM/Magnitude
    mv $WRK_DIR/QSM/Magnitude/*phase* $WRK_DIR/QSM/Phase
    # 1. Preparing magnitude and phase image as unzipped 4D NIFTI files
    GRE_MAG1=$(find $WRK_DIR/QSM/Magnitude/*echo-01*nii.gz)
    GRE_MAG2=$(find $WRK_DIR/QSM/Magnitude/*echo-02*nii.gz)
    GRE_MAG3=$(find $WRK_DIR/QSM/Magnitude/*echo-03*nii.gz)
    GRE_MAG4=$(find $WRK_DIR/QSM/Magnitude/*echo-04*nii.gz)
    GRE_MAG5=$(find $WRK_DIR/QSM/Magnitude/*echo-05*nii.gz)

    GRE_PHASE1=$(find $WRK_DIR/QSM/Phase/*echo-01*nii.gz)
    GRE_PHASE2=$(find $WRK_DIR/QSM/Phase/*echo-02*nii.gz)
    GRE_PHASE3=$(find $WRK_DIR/QSM/Phase/*echo-03*nii.gz)
    GRE_PHASE4=$(find $WRK_DIR/QSM/Phase/*echo-04*nii.gz)
    GRE_PHASE5=$(find $WRK_DIR/QSM/Phase/*echo-05*nii.gz)

    #  Start the QSM preprocessing
    Romeo
    QSM
  else
    echo "GE missing, skipping to next subject"
  fi
done
