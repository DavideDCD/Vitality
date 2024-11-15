#!/bin/bash
source project.sh

: '
wrapper script for anatomical images processing
requirements: fsl, ANTs
Davide Di Censo, @ITAB 2024
'

function registration() {
   MOVING=$WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_brain.nii.gz
   if [ -f $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_coreg.nii.gz ]; then
      echo "Registration already done...skipping to next task"
   else
      echo "Registering structural image to MNI space..."
      antsRegistration --dimensionality 3 --float 0 \
         --interpolation Linear --verbose 1 --use-histogram-matching 1 --winsorize-image-intensities [0.005,0.995] \
         --initial-moving-transform [$ATLAS, $MOVING,1] \
         --transform Rigid[0.1] \
         --metric MI[$ATLAS,$MOVING,1,32,Regular,0.3] \
         --convergence 500x250x100 --shrink-factors 4x2x1 \
         --smoothing-sigmas 2x1x0vox \
         --transform Affine[0.1] \
         --metric MI[$ATLAS,$MOVING,1,32,Regular,0.25] \
         --convergence 500x500x250x0 --shrink-factors 6x4x2x1 --smoothing-sigmas 3x2x1x0vox \
         --transform SyN[0.1,3,0] \
         --metric CC[$ATLAS,$MOVING,1,4] \
         --convergence 500x500x250x250 --shrink-factors 6x4x2x1 --smoothing-sigmas 3x2x1x0vox \
         --output [$PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_, $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_coreg.nii.gz]
   fi
}

function apply_transformation() {
   if [ -f $WRK_DIR/${SUBJ}_labels.nii.gz ]; then
      echo "Transormatiion already done...skipping to next task"
   else
      TFORMS="-t [ $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_0GenericAffine.mat , 1 ] -t $PROC_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1InverseWarp.nii.gz"
      antsApplyTransforms -d 3 -i $LABELS -r $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_brain.nii.gz -o $WRK_DIR/${SUBJ}_labels.nii.gz -n Multilabel $TFORMS
   fi
}

function write_jacobians() {
   if [ -f $REG_DIR/anat/${SUBJ}_geom_composite_volchange.nii.gz ]; then
      echo "Jacobians already done...skipping to next task"
   else
      # write non linear jacobians
      CreateJacobianDeterminantImage 3 $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1Warp.nii.gz $REG_DIR/anat/${SUBJ}_nonlin_logjacobian.nii.gz 1 0
      CreateJacobianDeterminantImage 3 $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1Warp.nii.gz $REG_DIR/anat/${SUBJ}_nonlin_jacobian.nii.gz 0 0
      fslmaths $REG_DIR/anat/${SUBJ}_nonlin_jacobian.nii.gz -sub 1 $REG_DIR/anat/${SUBJ}_nonlin_volchange.nii.gz

      # write geometric nonlinear jacobians
      CreateJacobianDeterminantImage 3 $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1Warp.nii.gz $REG_DIR/anat/${SUBJ}_geom_nonlin_logjacobian.nii.gz 1 1
      CreateJacobianDeterminantImage 3 $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1Warp.nii.gz $REG_DIR/anat/${SUBJ}_geom_nonlin_jacobian.nii.gz 0 1
      fslmaths $REG_DIR/anat/${SUBJ}_geom_nonlin_jacobian.nii.gz -sub 1 $REG_DIR/anat/${SUBJ}_geom_nonlin_volchange.nii.gz

      # write composite warp file
      antsApplyTransforms -d 3 -r $ATLAS -o [$WRK_DIR/${SUBJ}_composite_warp.nii.gz,1] -t $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1Warp.nii.gz -t $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_0GenericAffine.mat

      # write composite jacobians
      CreateJacobianDeterminantImage 3 $WRK_DIR/${SUBJ}_composite_warp.nii.gz $REG_DIR/anat/${SUBJ}_composite_logjacobian.nii.gz 1 0
      CreateJacobianDeterminantImage 3 $WRK_DIR/${SUBJ}_composite_warp.nii.gz $REG_DIR/anat/${SUBJ}_composite_jacobian.nii.gz 0 0
      fslmaths $REG_DIR/anat/${SUBJ}_composite_jacobian.nii.gz -sub 1 $REG_DIR/anat/${SUBJ}_composite_volchange.nii.gz

      # write geometric composite jacobians
      CreateJacobianDeterminantImage 3 $WRK_DIR/${SUBJ}_composite_warp.nii.gz $REG_DIR/anat/${SUBJ}_geom_composite_logjacobian.nii.gz 1 1
      CreateJacobianDeterminantImage 3 $WRK_DIR/${SUBJ}_composite_warp.nii.gz $REG_DIR/anat/${SUBJ}_geom_composite_jacobian.nii.gz 0 1
      fslmaths $REG_DIR/anat/${SUBJ}_geom_composite_jacobian.nii.gz -sub 1 $REG_DIR/anat/${SUBJ}_geom_composite_volchange.nii.gz
   fi
}

function tissue_segmentation() {
   if [ -f $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_brain_pveseg.nii.gz ]; then
      echo "Segmentation already done...skipping to next task"
   else
      fast -t 1 -n 3 -o $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_brain $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_brain.nii.gz 
   fi
}

function apply_transformation() {
   if [ -f $REG_DIR/anat/${SUBJ}_desc-R1_MP2RAGE_brain.nii.gz ]; then
      echo "R1 calc and warp already done...skipping to next task"
   else
      # calculate R1

      fslmaths $ROOT_DIR/$SUBJ/anat/${SUBJ}_desc-T1_MP2RAGE.nii.gz -recip $WRK_DIR/${SUBJ}_desc-R1_MP2RAGE.nii.gz
      fslmaths $WRK_DIR/${SUBJ}_desc-R1_MP2RAGE.nii.gz -mas $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_mask_resampled.nii.gz $WRK_DIR/${SUBJ}_desc-R1_MP2RAGE_brain.nii.gz

      antsApplyTransforms -d 3 -i $WRK_DIR/${SUBJ}_desc-R1_MP2RAGE_brain.nii.gz -r $ATLAS -o $REG_DIR/anat/${SUBJ}_desc-R1_MP2RAGE_brain.nii.gz -t $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_1Warp.nii.gz -t $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_anat2atlas_0GenericAffine.mat
fi
}

fortune
mapfile -t SCANS < subjects.txt #legge i soggetti dall'elenco

# SUBJ=$1
for SUBJ in ${SCANS[@]}; do
   sleep 2
   cowsay -f ghostbusters Processing: $SUBJ
   ## folder definitions
   WRK_DIR=$PROC_DIR/$SUBJ/anat
   mkdir -p $WRK_DIR
   mkdir -p $REG_DIR/anat/
   cd $WRK_DIR

   # brain extraction
   if [ -f $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_brain.nii.gz ]; then
      echo "BET already done...skipping to next task"
   else
      N4BiasFieldCorrection -d 3 -i $ROOT_DIR/$SUBJ/anat/${SUBJ}_inv-02_MP2RAGE.nii.gz -o $ROOT_DIR/$SUBJ/anat/${SUBJ}_inv-02_desc-N4_MP2RAGE.nii.gz

      ## if robusfov not needed comment the following 2 lines and uncomment the third line
      robustfov -b 200 -i $ROOT_DIR/$SUBJ/anat/${SUBJ}_inv-02_desc-N4_MP2RAGE.nii.gz -r $WRK_DIR/${SUBJ}_inv-02_desc-N4_cropped_MP2RAGE.nii.gz
      bet $WRK_DIR/${SUBJ}_inv-02_desc-N4_cropped_MP2RAGE.nii.gz $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_brain.nii.gz -m -f 0.38
      # bet $ROOT_DIR/$SUBJ/anat/${SUBJ}_inv-02_desc-N4_MP2RAGE.nii.gz $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_brain.nii.gz -m -f 0.6
      mv $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_brain_mask.nii.gz $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_mask.nii.gz
      ## antsBrainExtraction.sh -d 3 -a $ROOT_DIR/$SUBJ/anat/${SUBJ}_inv-02_desc-N4_MP2RAGE.nii.gz -e $TEMPLATE -m $PRIOR -o $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_brain
      ## mv $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_brainBrainExtractionBrain.nii.gz $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_brain.nii.gz
      ## mv $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_brainBrainExtractionMask.nii.gz $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_brain_mask.nii.gz  
      ## rm $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_brainBrainExtractionPrior0GenericAffine.mat


      antsApplyTransforms -d 3 -i $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_mask.nii.gz -r $ROOT_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE.nii.gz -o $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_mask_resampled.nii.gz -n NearestNeighbor 
      fslmaths $ROOT_DIR/$SUBJ/anat/${SUBJ}_desc-UNI_MP2RAGE.nii.gz -mas $WRK_DIR/${SUBJ}_inv-02_MP2RAGE_mask_resampled.nii.gz $WRK_DIR/${SUBJ}_desc-UNI_MP2RAGE_brain.nii.gz
   fi
   
   rm $WRK_DIR/${SUBJ}_inv-02_desc-N4_cropped_MP2RAGE.nii.gz

   registration
   apply_transformation
   write_jacobians
   tissue_segmentation
   apply_transformation
done
