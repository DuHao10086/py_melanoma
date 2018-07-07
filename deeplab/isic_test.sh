#!/bin/bash

set -e

cd ..

export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

CURRENT_DIR=$(pwd)
WORK_DIR="${CURRENT_DIR}/deeplab"

# Run model_test first to make sure the PYTHONPATH is correctly set.
#python "${WORK_DIR}"/model_test.py -v

echo "Covert has been done. "

cd "${CURRENT_DIR}"

# Set up the working directories.
ISIC_FOLDER="/data/volume01/datasets"
EXP_FOLDER="exp/train_on_trainval_set"
INIT_FOLDER="${ISIC_FOLDER}/init_models"
TRAIN_LOGDIR="${ISIC_FOLDER}/${EXP_FOLDER}/train"
EVAL_LOGDIR="${ISIC_FOLDER}/${EXP_FOLDER}/eval"
VIS_LOGDIR="${ISIC_FOLDER}/${EXP_FOLDER}/vis"
EXPORT_DIR="${ISIC_FOLDER}/${EXP_FOLDER}/export"
mkdir -p "${INIT_FOLDER}"
mkdir -p "${TRAIN_LOGDIR}"
mkdir -p "${EVAL_LOGDIR}"
mkdir -p "${VIS_LOGDIR}"
mkdir -p "${EXPORT_DIR}"

DATASET="ISIC2017"

# Copy locally the trained checkpoint as the initial checkpoint.
TF_INIT_ROOT="http://download.tensorflow.org/models"
TF_INIT_CKPT="deeplabv3_pascal_train_aug_2018_01_04.tar.gz"
cd "${INIT_FOLDER}"
wget -nd -c "${TF_INIT_ROOT}/${TF_INIT_CKPT}"
tar -xf "${TF_INIT_CKPT}"
cd "${CURRENT_DIR}"

ISIC_DATASET="${ISIC_FOLDER}/tfrecord"

# Training.
#NUM_ITERATIONS=30000
#python "${WORK_DIR}"/train.py \
#  --logtostderr \
#  --train_split="trainval" \
#  --model_variant="xception_65" \
#  --atrous_rates=6 \
#  --atrous_rates=12 \
#  --atrous_rates=18 \
#  --output_stride=16 \
#  --decoder_output_stride=4 \
#  --train_crop_size=513 \
#  --train_crop_size=513 \
#  --train_batch_size=4 \
#  --training_number_of_steps="${NUM_ITERATIONS}" \
#  --fine_tune_batch_norm=true \
#  --tf_initial_checkpoint="${INIT_FOLDER}/deeplabv3_pascal_train_aug/model.ckpt" \
#  --train_logdir="${TRAIN_LOGDIR}" \
#  --dataset_dir="${ISIC_DATASET}"

# 513 is default
python "${WORK_DIR}"/eval.py \
  --logtostderr \
  --eval_split="val" \
  --model_variant="xception_65" \
  --atrous_rates=6 \
  --atrous_rates=12 \
  --atrous_rates=18 \
  --output_stride=16 \
  --decoder_output_stride=4 \
  --eval_crop_size=513 \
  --eval_crop_size=513 \
  --checkpoint_dir="${TRAIN_LOGDIR}" \
  --eval_logdir="${EVAL_LOGDIR}" \
  --dataset_dir="${ISIC_DATASET}" \
  --max_number_of_evaluations=1

