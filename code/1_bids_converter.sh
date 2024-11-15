#!/bin/bash
source project.sh

: '
Run dcm2bids_scaffold and put this script and project.sh in code folder.
Edit participant.tsv, putting the dicom folder name in the dicom_dir field.
Optional, install pydeface (pip install pydeface) to remove facial landmarks from the images.
Davide Di Censo & Maria Giulia Tullo, @ITAB 2024
'
fortune

# Set the path to the TSV file
tsv_file="$ROOT_DIR/participants.tsv"

# Print the content of the TSV file
echo "Contents of participants.tsv:"
cat "$tsv_file"

# Read participant IDs, session IDs, and paths from TSV file
tail -n +2 "$tsv_file" | while IFS=$'\t' read -r subj _ _ _ path; do
    echo "Processing participant: ${subj}, path: ${path}"
    # Run dcm2bids or your processing command
    dcm2bids -d $RAW_DIR/$path -p $subj -c $SCRIPT_DIR/dcm2bids_instructions.json -o $ROOT_DIR/ --auto_extract_entities # Replace this with your actual dcm2bids command
    # pydeface --outfile "$ROOT_DIR/sub-$subj/ses-$ses/anat/sub-$subj_ses-$ses_T1w_defaced.nii.gz" "$ROOT_DIR/sub-$subj/ses-$ses/anat/sub-$subj_ses-$ses_T1w.nii.gz"
done

chmod -R 2770 $ROOT_DIR