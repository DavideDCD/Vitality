#!/bin/bash
source ./project.sh

mkdir -p $FIG_DIR/DTI
mkdir -p $FIG_DIR/SANDI
mkdir -p $FIG_DIR/perf
mkdir -p $FIG_DIR/func

AXIS=$1

# DTI_MAPS=('MD' 'RD' 'L1') 

# $SLICE_CMD $ATLAS $FIG_DIR/DTI/FA_corrp_stat_${1}_positive_diff.png --overlay $STATS_DIR/DTI/FA_change_con1.nii.gz --overlay_scale 100 \
#     --overlay_alpha $STATS_DIR/DTI/FA_change_tfce_corrp_tstat1.nii.gz --overlay_alpha_lim 0.8 1 --slice_lims 0.4 0.9 --slice_rows 2 --slice_cols 7 \
#     --overlay_lim 0 10 --overlay_map "YlOrRd" --overlay_label "Pre vs Post TASK FA positive differences %" --contour 0.99 --mask $FIG_MASK --dpi 200 \
#     --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

# $SLICE_CMD $ATLAS $FIG_DIR/DTI/FA_corrp_stat_${1}_negative_diff.png --overlay $STATS_DIR/DTI/FA_change_con2.nii.gz --overlay_scale 100 \
#     --overlay_alpha $STATS_DIR/DTI/FA_change_tfce_corrp_tstat2.nii.gz --overlay_alpha_lim 0.8 1 --slice_lims 0.4 0.9 --slice_rows 2 --slice_cols 7 \
#     --overlay_lim 0 10 --overlay_map "YlGnBu" --overlay_label "Pre vs Post TASK FA negative differences %" --contour 0.99 --mask $FIG_MASK --dpi 200 \
#     --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

# for MAP in ${DTI_MAPS[@]}; do

#     $SLICE_CMD $ATLAS $FIG_DIR/DTI/${MAP}_corrp_stat_${1}_positive_diff.png --overlay $STATS_DIR/DTI/${MAP}_change_con1.nii.gz --overlay_scale 1000 \
#         --overlay_alpha $STATS_DIR/DTI/${MAP}_change_tfce_corrp_tstat1.nii.gz --overlay_alpha_lim 0.8 1 --slice_lims 0.4 0.9 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 0.5 --overlay_map "YlOrRd" --overlay_label "Pre vs Post TASK ${MAP} positive differences x10$^{-3}$ mm$^2$/s" --contour 0.95 --mask $FIG_MASK --dpi 100 \
#         --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

#     $SLICE_CMD $ATLAS $FIG_DIR/DTI/${MAP}_corrp_stat_${1}_negative_diff.png --overlay $STATS_DIR/DTI/${MAP}_change_con2.nii.gz --overlay_scale 1000 \
#         --overlay_alpha $STATS_DIR/DTI/${MAP}_change_tfce_corrp_tstat2.nii.gz --overlay_alpha_lim 0.8 1 --slice_lims 0.4 0.9 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 0.5 --overlay_map "YlGnBu" --overlay_label "Pre vs Post TASK ${MAP} negative differences x10$^{-3}$ mm$^2$/s" --contour 0.95 --mask $FIG_MASK --dpi 100 \
#         --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

# done

# SANDI_MAPS=('Rsoma')

# for MAP in ${SANDI_MAPS[@]}; do

#     $SLICE_CMD $ATLAS $FIG_DIR/SANDI/${MAP}_corrp_stat_${1}_positive_diff.png --overlay $STATS_DIR/SANDI_old/${MAP}_change_con1.nii.gz --overlay_scale 1 \
#         --overlay_alpha $STATS_DIR/SANDI_old/${MAP}_change_tfce_corrp_tstat1.nii.gz --overlay_alpha_lim 0.8 1 --slice_lims 0.4 0.9 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 1 --overlay_map "YlOrRd" --overlay_label "Pre vs Post TASK ${MAP} positive differences um" --contour 0.95 --mask $FIG_MASK --dpi 100 \
#         --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

#     $SLICE_CMD $ATLAS $FIG_DIR/SANDI/${MAP}_corrp_stat_${1}_negative_diff.png --overlay $STATS_DIR/SANDI_old/${MAP}_change_con2.nii.gz --overlay_scale 1 \
#         --overlay_alpha $STATS_DIR/SANDI_old/${MAP}_change_tfce_corrp_tstat2.nii.gz --overlay_alpha_lim 0.8 1 --slice_lims 0.4 0.9 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 1 --overlay_map "YlGnBu" --overlay_label "Pre vs Post TASK ${MAP} negative differences um" --contour 0.95 --mask $FIG_MASK --dpi 100 \
#         --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

# done

# SANDI_MAPS=('fsoma' 'fextra' 'fneurite')

# for MAP in ${SANDI_MAPS[@]}; do

#     $SLICE_CMD $ATLAS $FIG_DIR/SANDI/${MAP}_corrp_stat_${1}_positive_diff.png --overlay $STATS_DIR/SANDI_old/${MAP}_change_con1.nii.gz --overlay_scale 100 \
#         --overlay_alpha $STATS_DIR/SANDI_old/${MAP}_change_tfce_corrp_tstat1.nii.gz --overlay_alpha_lim 0.8 1 --slice_lims 0.4 0.9 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 1 --overlay_map "YlOrRd" --overlay_label "Pre vs Post TASK ${MAP} positive differences %" --contour 0.95 --mask $FIG_MASK --dpi 100 \
#         --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

#     $SLICE_CMD $ATLAS $FIG_DIR/SANDI/${MAP}_corrp_stat_${1}_negative_diff.png --overlay $STATS_DIR/SANDI_old/${MAP}_change_con2.nii.gz --overlay_scale 100 \
#         --overlay_alpha $STATS_DIR/SANDI_old/${MAP}_change_tfce_corrp_tstat2.nii.gz --overlay_alpha_lim 0.8 1 --slice_lims 0.4 0.9 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 1 --overlay_map "YlGnBu" --overlay_label "Pre vs Post TASK ${MAP} negative differences %" --contour 0.95 --mask $FIG_MASK --dpi 100 \
#         --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

# done

# SANDI_MAPS=('De' 'Din')

# for MAP in ${SANDI_MAPS[@]}; do

#     $SLICE_CMD $ATLAS $FIG_DIR/SANDI/${MAP}_corrp_stat_${1}_positive_diff.png --overlay $STATS_DIR/SANDI_old/${MAP}_change_con1.nii.gz --overlay_scale 100 \
#         --overlay_alpha $STATS_DIR/SANDI_old/${MAP}_change_tfce_corrp_tstat1.nii.gz --overlay_alpha_lim 0.8 1 --slice_lims 0.4 0.9 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 1 --overlay_map "YlOrRd" --overlay_label "Pre vs Post TASK ${MAP} positive differences x10$^{-3}$ mm$^2$/s" --contour 0.95 --mask $FIG_MASK --dpi 100 \
#         --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

#     $SLICE_CMD $ATLAS $FIG_DIR/SANDI/${MAP}_corrp_stat_${1}_negative_diff.png --overlay $STATS_DIR/SANDI_old/${MAP}_change_con2.nii.gz --overlay_scale 100 \
#         --overlay_alpha $STATS_DIR/SANDI_old/${MAP}_change_tfce_corrp_tstat2.nii.gz --overlay_alpha_lim 0.8 1 --slice_lims 0.4 0.9 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 1 --overlay_map "YlGnBu" --overlay_label "Pre vs Post TASK ${MAP} negative differences x10$^{-3}$ mm$^2$/s" --contour 0.95 --mask $FIG_MASK --dpi 100 \
#         --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

# done

PERF_MAPS=('CMRO2' 'OEF' 'CVR')

# for MAP in ${PERF_MAPS[@]}; do

#     $SLICE_CMD $ATLAS $FIG_DIR/perf/${MAP}_corrp_stat_${1}_positive_diff.png --overlay $STATS_DIR/perf/task-bh_dexi_volreg_asl_${MAP}_change_con1.nii.gz --overlay_scale 1000 \
#         --overlay_alpha $STATS_DIR/perf/task-bh_dexi_volreg_asl_${MAP}_change_tfce_corrp_tstat1.nii.gz --overlay_alpha_lim 0.5 1 --slice_lims 0.1 0.9 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 1 --overlay_map "YlOrRd" --overlay_label "Pre vs Post TASK ${MAP} positive differences" --contour 0.95 --mask $FIG_MASK --dpi 100 \
#         --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

#     $SLICE_CMD $ATLAS $FIG_DIR/perf/${MAP}_corrp_stat_${1}_negative_diff.png --overlay $STATS_DIR/perf/task-bh_dexi_volreg_asl_${MAP}_change_con2.nii.gz --overlay_scale 1000 \
#         --overlay_alpha $STATS_DIR/perf/task-bh_dexi_volreg_asl_${MAP}_change_tfce_corrp_tstat2.nii.gz --overlay_alpha_lim 0.5 1 --slice_lims 0.1 0.9 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 1 --overlay_map "YlGnBu" --overlay_label "Pre vs Post TASK ${MAP} negative differences" --contour 0.95 --mask $FIG_MASK --dpi 100 \
#         --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

#     $SLICE_CMD $ATLAS $FIG_DIR/perf/${MAP}_p_stat_${1}_positive_diff.png --overlay $STATS_DIR/perf/task-bh_dexi_volreg_asl_${MAP}_change_con1.nii.gz --overlay_scale 1000 \
#         --overlay_alpha $STATS_DIR/perf/task-bh_dexi_volreg_asl_${MAP}_change_tfce_p_tstat1.nii.gz --overlay_alpha_lim 0.9 1 --slice_lims 0.1 0.9 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 1 --overlay_map "YlOrRd" --overlay_label "Pre vs Post TASK ${MAP} positive differences" --contour 0.99 --mask $FIG_MASK --dpi 100 \
#         --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

#     $SLICE_CMD $ATLAS $FIG_DIR/perf/${MAP}_p_stat_${1}_negative_diff.png --overlay $STATS_DIR/perf/task-bh_dexi_volreg_asl_${MAP}_change_con2.nii.gz --overlay_scale 1000 \
#         --overlay_alpha $STATS_DIR/perf/task-bh_dexi_volreg_asl_${MAP}_change_tfce_p_tstat2.nii.gz --overlay_alpha_lim 0.9 1 --slice_lims 0.1 0.9 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 1 --overlay_map "YlGnBu" --overlay_label "Pre vs Post TASK ${MAP} negative differences" --contour 0.99 --mask $FIG_MASK --dpi 100 \
#         --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

# done

# fslmaths $STATS_DIR/perf_check/task-rest_desc-preproc_asl_CBF_change_con1.nii.gz -mas $FIG_DIR/figure_mask_resampled.nii.gz $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_con1.nii.gz
# fslmaths $STATS_DIR/perf_check/task-rest_desc-preproc_asl_CBF_change_tfce_corrp_tstat1.nii.gz -mas $FIG_DIR/figure_mask_resampled.nii.gz $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_tfce_corrp_tstat1.nii.gz
# fslmaths $STATS_DIR/perf_check/task-rest_desc-preproc_asl_CBF_change_con2.nii.gz -mas $FIG_DIR/figure_mask_resampled.nii.gz $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_con2.nii.gz
# fslmaths $STATS_DIR/perf_check/task-rest_desc-preproc_asl_CBF_change_tfce_corrp_tstat2.nii.gz -mas $FIG_DIR/figure_mask_resampled.nii.gz $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_tfce_corrp_tstat2.nii.gz

# $SLICE_CMD $ATLAS $FIG_DIR/perf/CBF_corrp_stat_${1}_positive_diff.png --overlay $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_con1.nii.gz --overlay_scale 1 \
#     --overlay_alpha $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_tfce_corrp_tstat1.nii.gz --overlay_alpha_lim 0 1 --slice_lims 0.1 0.9 --overlay_mask $FIG_DIR/figure_mask_resampled.nii.gz --slice_rows 3 --slice_cols 5 \
#     --overlay_lim 0 10 --overlay_map "YlOrRd" --overlay_label "Post - Pre TASK CBF positive differences [ml/100g]" --contour 0.95 --mask $FIG_MASK --dpi 100 \
#     --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

# $SLICE_CMD $ATLAS $FIG_DIR/perf/CBF_corrp_stat_${1}_negative_diff.png --overlay $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_con2.nii.gz --overlay_scale 1 \
#     --overlay_alpha $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_tfce_corrp_tstat2.nii.gz --overlay_alpha_lim 0 1 --slice_lims 0.1 0.9 --overlay_mask $FIG_DIR/figure_mask_resampled.nii.gz --slice_rows 3 --slice_cols 5 \
#     --overlay_lim 0 10 --overlay_map "YlGnBu" --overlay_label "Post - Pre TASK CBF negative differences [ml/100g]" --contour 0.95 --mask $FIG_MASK --dpi 100 \
#     --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

# CBF UNCORRP STATS

# fslmaths $STATS_DIR/perf_check/task-rest_desc-preproc_asl_CBF_change_tfce_p_tstat1.nii.gz -mas $FIG_DIR/figure_mask_resampled.nii.gz $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_tfce_p_tstat1.nii.gz
# fslmaths $STATS_DIR/perf_check/task-rest_desc-preproc_asl_CBF_change_tfce_p_tstat2.nii.gz -mas $FIG_DIR/figure_mask_resampled.nii.gz $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_tfce_p_tstat2.nii.gz


# $SLICE_CMD $ATLAS $FIG_DIR/perf/CBF_p_stat_${1}_positive_diff.png --overlay $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_con1.nii.gz --overlay_scale 1 \
#     --overlay_alpha $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_tfce_p_tstat1.nii.gz --overlay_alpha_lim 0.9 1 --overlay_mask $FIG_DIR/figure_mask_resampled.nii.gz --slice_lims 0.1 0.9 --slice_rows 3 --slice_cols 5 \
#     --overlay_lim 0 10 --overlay_map "YlOrRd" --overlay_label "Post - Pre TASK CBF positive differences [ml/100g]" --contour 0.99 --mask $FIG_MASK --dpi 100 \
#     --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

# $SLICE_CMD $ATLAS $FIG_DIR/perf/CBF_p_stat_${1}_negative_diff.png --overlay $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_con2.nii.gz --overlay_scale 1 \
#     --overlay_alpha $FIG_DIR/perf/task-rest_desc-preproc_asl_CBF_change_tfce_p_tstat2.nii.gz --overlay_alpha_lim 0.9 1 --overlay_mask $FIG_DIR/figure_mask_resampled.nii.gz --slice_lims 0.1 0.9 --slice_rows 3 --slice_cols 5 \
#     --overlay_lim 0 10 --overlay_map "YlGnBu" --overlay_label "Post - Pre TASK CBF negative differences [ml/100g]" --contour 0.99 --mask $FIG_MASK --dpi 100 \
#     --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

# fslmerge -t $REG_DIR/VITALITY_task-rest_run-01_CBF.nii.gz $REG_DIR/perf/*_task-rest_run-01_desc-preproc_asl_CBF_map_masked.nii.gz
# fslmaths $REG_DIR/VITALITY_task-rest_run-01_CBF.nii.gz -Tmean $REG_DIR/VITALITY_task-rest_run-01_CBF_average.nii.gz

# fslmerge -t $REG_DIR/VITALITY_task-rest_run-02_CBF.nii.gz $REG_DIR/perf/*_task-rest_run-02_desc-preproc_asl_CBF_map_masked.nii.gz
# fslmaths $REG_DIR/VITALITY_task-rest_run-02_CBF.nii.gz -Tmean $REG_DIR/VITALITY_task-rest_run-02_CBF_average.nii.gz

# fslmerge -t $REG_DIR/VITALITY_task-rest_CBF_differences.nii.gz $REG_DIR/perf/*_task-rest_desc-preproc_asl_CBF_differences.nii.gz
# fslmaths $REG_DIR/VITALITY_task-rest_CBF_differences.nii.gz -Tmean $REG_DIR/VITALITY_task-rest_CBF_differences_average.nii.gz

# $SLICE_CMD $ATLAS $FIG_DIR/VITALITY_task-rest_run-01_CBF.png --overlay $REG_DIR/VITALITY_task-rest_run-01_CBF_average.nii.gz  \
#         --overlay_alpha $ATLAS_MASK --overlay_alpha_lim 0 1 --slice_lims 0.3 0.7 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 80 --overlay_map "Spectral_r" --base_label "Average CBF run-01 [ml/100g]" --mask $ATLAS_MASK --overlay_mask_thresh 0.1 --dpi 300 \
#         --font "Monospace" --fontsize 15 --orient 'clin' --bar_pos 'south'


# $SLICE_CMD $ATLAS $FIG_DIR/VITALITY_task-rest_run-02_CBF.png --overlay $REG_DIR/VITALITY_task-rest_run-02_CBF_average.nii.gz  \
#         --overlay_alpha $ATLAS_MASK --overlay_alpha_lim 0 1 --slice_lims 0.3 0.7 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim 0 80 --overlay_map "Spectral_r" --base_label "Average CBF run-02 [ml/100g]" --mask $ATLAS_MASK --overlay_mask_thresh 0.1  --dpi 300 \
#         --font "Monospace" --fontsize 15 --orient 'clin' --bar_pos 'south'

# $SLICE_CMD $ATLAS $FIG_DIR/VITALITY_task-rest_CBF_differences.png --overlay $REG_DIR/VITALITY_task-rest_CBF_differences_average.nii.gz  \
#         --overlay_alpha $ATLAS_MASK --overlay_alpha_lim 0 1 --slice_lims 0.3 0.7 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim -5 5 --overlay_map "Spectral_r" --base_label "CBF differences [ml/100g]" --mask $ATLAS_MASK --overlay_mask_thresh 0.1  --dpi 300 \
#         --font "Monospace" --fontsize 15 --orient 'clin' --bar_pos 'south'

# for MAP in ${PERF_MAPS[@]}; do

#     fslmerge -t $REG_DIR/VITALITY_task-bh_run-01_${MAP}.nii.gz $REG_DIR/perf/*_task-bh_run-01_dexi_volreg_asl_topup_${MAP}_map.nii.gz
#     fslmaths $REG_DIR/VITALITY_task-bh_run-01_${MAP}.nii.gz -Tmean $REG_DIR/VITALITY_task-bh_run-01_${MAP}_average.nii.gz

#     fslmerge -t $REG_DIR/VITALITY_task-bh_run-02_${MAP}.nii.gz $REG_DIR/perf/*_task-bh_run-02_dexi_volreg_asl_topup_${MAP}_map.nii.gz
#     fslmaths $REG_DIR/VITALITY_task-bh_run-02_${MAP}.nii.gz -Tmean $REG_DIR/VITALITY_task-bh_run-02_${MAP}_average.nii.gz

#     fslmerge -t $REG_DIR/VITALITY_task-bh_${MAP}_differences.nii.gz $REG_DIR/perf/*_task-bh_dexi_volreg_asl_${MAP}_differences.nii.gz
#     fslmaths $REG_DIR/VITALITY_task-bh_${MAP}_differences.nii.gz -Tmean $REG_DIR/VITALITY_task-bh_${MAP}_differences_average.nii.gz

#     $SLICE_CMD $ATLAS $FIG_DIR/VITALITY_task-bh_run-01_${MAP}.png --overlay $REG_DIR/VITALITY_task-bh_run-01_${MAP}_average.nii.gz  \
#             --overlay_alpha $ATLAS_MASK --overlay_alpha_lim 0 1 --slice_lims 0.3 0.7 --slice_rows 3 --slice_cols 5 \
#             --overlay_lim 0 80 --overlay_map "Spectral_r" --base_label "Average ${MAP} run-01" --mask $ATLAS_MASK --overlay_mask_thresh 0.1 --dpi 300 \
#             --font "Monospace" --fontsize 15 --orient 'clin' --bar_pos 'south'


#     $SLICE_CMD $ATLAS $FIG_DIR/VITALITY_task-bh_run-02_${MAP}.png --overlay $REG_DIR/VITALITY_task-bh_run-02_${MAP}_average.nii.gz  \
#             --overlay_alpha $ATLAS_MASK --overlay_alpha_lim 0 1 --slice_lims 0.3 0.7 --slice_rows 3 --slice_cols 5 \
#             --overlay_lim 0 80 --overlay_map "Spectral_r" --base_label "Average ${MAP} run-02" --mask $ATLAS_MASK --overlay_mask_thresh 0.1  --dpi 300 \
#             --font "Monospace" --fontsize 15 --orient 'clin' --bar_pos 'south'

#     $SLICE_CMD $ATLAS $FIG_DIR/VITALITY_task-bh_${MAP}_differences.png --overlay $REG_DIR/VITALITY_task-bh_${MAP}_differences_average.nii.gz  \
#         --overlay_alpha $ATLAS_MASK --overlay_alpha_lim 0 1 --slice_lims 0.3 0.7 --slice_rows 3 --slice_cols 5 \
#         --overlay_lim -5 5 --overlay_map "Spectral_r" --base_label "${MAP} differences" --mask $ATLAS_MASK --overlay_mask_thresh 0.1  --dpi 300 \
#         --font "Monospace" --fontsize 15 --orient 'clin' --bar_pos 'south'

# done

$SLICE_CMD $ATLAS $FIG_DIR/func/HC_task_positive_activation_map.png --overlay $FEAT_DIR/3rd_level/task_positive/gfeat/cope1.feat/stats/cope1.nii.gz --overlay_scale 1 \
    --overlay_alpha $FEAT_DIR/3rd_level/task_positive/gfeat/cope1.feat/rendered_thresh_zstat1.nii.gz --overlay_alpha_lim 3.1 6 --slice_lims 0.1 0.9 --slice_rows 3 --slice_cols 5 \
    --overlay_lim 0 80 --overlay_map "YlOrRd" --overlay_label "Task-Glove activation map (zstat)" --mask $FIG_MASK --overlay_mask $FIG_MASK --dpi 100 \
    --font "Ubuntu" --fontsize 10 --orient 'clin' --bar_pos 'south' --slice_axis $1

