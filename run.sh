#!/bin/bash

HOME_DIR=$HOME/workshop/ImageMagick6
BIN_DIR=$HOME_DIR/utilities

CONVERT=$BIN_DIR/convert
COMPARE=$BIN_DIR/compare
MOGRIFY=$BIN_DIR/mogrify
MONTAGE=$BIN_DIR/montage

# Run the convert command to sharpen a picture.
CMD="$BIN_DIR/convert photo.jpg -sharpen 0x1 reconstruct.jpg"
echo "Running $CMD..."
i=1
#time LD_PRELOAD=$PRELOAD_LIB $CMD &> out$i.txt
time $CMD &> out$i.txt

# Compare two pictures, store the diff into a png picture.
CMD="$BIN_DIR/compare -compose src photo.jpg reconstruct.jpg diff.png"
echo "Running $CMD..."
i=2
#time LD_PRELOAD=$PRELOAD_LIB $CMD &> out$i.txt
time $CMD &> out$i.txt

# Run the mogrify command to resize a picture.
cp photo.jpg rose.jpg
CMD="$BIN_DIR/mogrify -resize 50% rose.jpg"
echo "Running $CMD..."
i=3
#time LD_PRELOAD=$PRELOAD_LIB $CMD &> out$i.txt
time $CMD &> out$i.txt

# Another compare command.
CMD="$BIN_DIR/compare photo.jpg reconstruct.jpg diff.png"
echo "Running $CMD..."
i=4
#time LD_PRELOAD=$PRELOAD_LIB $CMD &> out$i.txt
time $CMD &> out$i.txt

# Another compare command.
CMD="$BIN_DIR/compare -channel red -metric PSNR photo.jpg reconstruct.jpg difference.png"
echo "Running $CMD..."
i=5
#time LD_PRELOAD=$PRELOAD_LIB $CMD &> out$i.txt
time $CMD &> out$i.txt

# Montage command.
CMD="$BIN_DIR/montage photo.jpg reconstruct.jpg frame.jpg"
echo "Running $CMD..."
i=6
#time LD_PRELOAD=$PRELOAD_LIB $CMD &> out$i.txt
time $CMD &> out$i.txt
