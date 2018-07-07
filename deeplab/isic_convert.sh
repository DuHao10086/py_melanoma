#!/bin/env bash

set -e

cd ..

export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

CURRENT_DIR=$(pwd)
#WORK_DIR='/data/volume01/ISIC-2017/Part1'

ISIC_ROOT='/data/volume01/datasets/ISIC2017'

# Skip removing color map
echo "Skip removing color map part."
SEMANTIC_SEG_FOLDER="${ISIC_ROOT}/label_trainval"
# Build TFRecords of the dataset
#First, create output directory for storing TFRecords.
OUTPUT_DIR="${ISIC_ROOT}/tfrecord"
mkdir -p ${OUTPUT_DIR}

IMAGE_FOLDER="${ISIC_ROOT}/image_trainval"
LIST_FOLDER="${ISIC_ROOT}/ImageSets"

echo "Converting ISIC 2017 data..."
cd "./datasets"
python ./build_isic_data.py \
  --image_folder="${IMAGE_FOLDER}" \
  --semantic_segmentation_folder="${SEMANTIC_SEG_FOLDER}" \
  --list_folder="${LIST_FOLDER}" \
  --image_format="jpg" \
  --output_dir="${OUTPUT_DIR}"
