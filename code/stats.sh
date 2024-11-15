#!/bin/bash 
set -eux
### set up variables ###
source ./project.sh

randomise_dir="$STATS_DIR/perf_thesis"
mkdir -p $randomise_dir
mapfile -t SCANS < stats_thesis.txt #read subjects from textfile

function merge_and_setup() {
    IN="$1"
    OUT="$2"
    shift 2
    SCANS=("$@")

    cd $REG_DIR/perf
    qi glm_setup --sort --groups=$SCRIPT_DIR/groups_thesis.txt --covars=$SCRIPT_DIR/covars_thesis.txt --out=${randomise_dir}/${OUT}.nii.gz -v ${SCANS[@]/%/$IN} --design=${randomise_dir}/stats.design
    qi glm_contrasts ${randomise_dir}/${OUT}.nii.gz ${randomise_dir}/stats.design ${randomise_dir}/ttest.con --out=${randomise_dir}/${OUT}_ --verbose
    Text2Vest $randomise_dir/stats.design $randomise_dir/stats.mat
}

function launch_randomise() {
   randomise_parallel -i ${randomise_dir}/${1}.nii.gz \
       -o ${randomise_dir}/${1} \
       -m $2 \
       -d ${randomise_dir}/stats.mat \
       -t ${randomise_dir}/ttest.con -f ${randomise_dir}/ftests.fts \
       -n 10000 -T -x --uncorrp
}

# function launch_randomise() {
#     randomise_parallel -i ${randomise_dir}/${1}.nii.gz -o ${randomise_dir}/${1} -1 -T
# }

# function run_randomise() {
#     merge_and_setup $1 ${MAP}_change "${SCANS[@]}"
#     launch_randomise ${MAP}_change $ATLAS_MASK
# }

PERF_MAPS=('task-rest_desc-preproc_asl_CBF' 'task-bh_dexi_volreg_asl_CMRO2' 'task-bh_dexi_volreg_asl_OEF' 'task-bh_dexi_volreg_asl_CVR')
# Text2Vest $SCRIPT_DIR/contrasts.txt $randomise_dir/ttest.con
# Text2Vest $SCRIPT_DIR/ftests.txt $randomise_dir/ftests.fts
for MAP in ${PERF_MAPS[@]}; do
    merge_and_setup _${MAP}_differences.nii.gz ${MAP}_change "${SCANS[@]}"
    launch_randomise ${MAP}_change $ATLAS2_MASK
done

## testing run 2 > run 1 for fneurite

# SANDI_MAPS=('Rsoma' 'fsoma' 'fneurite' 'Din' 'De')
# for MAP in ${SANDI_MAPS[@]}; do
#     run_randomise _SANDI-fit_${MAP}_differences.nii.gz
# done


# DTI_MAPS=('FA' 'L1' 'MD' 'RD')
# for MAP in ${DTI_MAPS[@]}; do
#     run_randomise _dti_${MAP}_differences.nii.gz
# done
