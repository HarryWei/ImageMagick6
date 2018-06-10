#!/bin/bash
#
# Weiwei Jia <harryxiyou@gmail.com> (Bash) 2018
#

#
# XXX: Fix for "convert: no decode delegate for this image format "
#http://blog.ericlamb.net/2008/11/fix-for-convert-no-decode-delegate-for-this-image-format/
#https://askubuntu.com/questions/211627/how-to-add-support-for-the-jpeg-image-format
# sudo apt-get install libjpeg62
# sudo apt-get install libjpeg62-dev
#

kvm1="kvm1"
kvm2="kvm1"
ip1="192.168.122.96"
ip2="192.168.122.98"
ctx=$2

#TODO: will be used to represent thread nums.
thread_num=$1

#mount disk
#ssh $kvm1@$ip1 "/home/$kvm1/vMigrater/scripts/mount.sh"
#ssh $kvm2@$ip2 "/home/$kvm2/vMigrater/scripts/mount.sh"

HOME_DIR="/home/kvm1/workshop/vPair/apps/ImageMagick6/utilities"
compare_bin="$HOME_DIR/compare"
convert_bin="$HOME_DIR/convert"
mogrify_bin="$HOME_DIR/mogrify"
montage_bin="$HOME_DIR/montage"
m122="$HOME_DIR/122m.jpg"
m78="$HOME_DIR/78m.jpg"
k150="$HOME_DIR/150k.jpg"
tmp="$HOME_DIR/tmp.jpg"

#compare
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $compare_bin $m122 $k150 $tmp" &>> $ctx/vm1.compare &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $compare_bin $m122 $k150 $tmp" &>> $ctx/vm2.compare
	sleep 60
done

#compare channel_red
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $compare_bin -channel red -metric PSNR $m122 $k150 $tmp" &>> $ctx/vm1.compare.channel_red &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $compare_bin -channel red -metric PSNR $m122 $k150 $tmp" &>> $ctx/vm2.compare.channel_red
	sleep 60
done

#compare compose
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $compare_bin -compose src $m122 $k150 $tmp" &>> $ctx/vm1.compare.compose &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $compare_bin -compose src $m122 $k150 $tmp" &>> $ctx/vm2.compare.compose
	sleep 60
done

#convert edge_detect
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $m122 -colorspace Gray  -edge 1 -negate $tmp" &>> $ctx/vm1.convert.edge_detect &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $m122 -colorspace Gray  -edge 1 -negate $tmp" &>> $ctx/vm2.convert.edge_detect
	sleep 60
done

#convert blur
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $m122 -blur 0x8 $tmp" &>> $ctx/vm1.convert.blur &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $m122 -blur 0x8 $tmp" &>> $ctx/vm2.convert.blur
	sleep 60
done

#convert charcoal_effect
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $m122 -charcoal 3 $tmp" &>> $ctx/vm1.convert.charcoal &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $m122 -charcoal 3 $tmp" &>> $ctx/vm2.convert.charcoal
	sleep 60
done

#convert draw
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin -size 15360x8640 gradient:green-yellow $tmp" &>> $ctx/vm1.convert.draw &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin -size 15360x8640 gradient:green-yellow $tmp" &>> $ctx/vm2.convert.draw
	sleep 60
done

#convert paint_effect
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $m122 -morphology CloseI Disk:2.5 $tmp" &>> $ctx/vm1.convert.paint_effect &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $m122 -morphology CloseI Disk:2.5 $tmp" &>> $ctx/vm2.convert.paint_effect
	sleep 60
done

#convert sharpen
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $m122 -sharpen 0x1 $tmp" &>> $ctx/vm1.convert.sharpen &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $m122 -sharpen 0x1 $tmp" &>> $ctx/vm2.convert.sharpen
	sleep 60
done

#convert fft
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $m122 -fft +depth +adjoin $tmp" &>> $ctx/vm1.convert.fft &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $m122 -fft +depth +adjoin $tmp" &>> $ctx/vm2.convert.fft
	sleep 60
done

#convert shear
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $m122 -background Blue  -shear 20x0 $tmp" &>> $ctx/vm1.convert.shear &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $m122 -background Blue  -shear 20x0 $tmp" &>> $ctx/vm2.convert.shear
	sleep 60
done

#mogrify resize
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $mogrify_bin -resize 150% $m122" &>> $ctx/vm1.mogrify.resize &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $mogrify_bin -resize 150% $m122" &>> $ctx/vm2.mogrify.resize
	sleep 60
done

#mogrify segment
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $mogrify_bin -segment 128000x60 $m78" &>> $ctx/vm1.mogrify.segment &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $mogrify_bin -segment 128000x60 $m78" &>> $ctx/vm2.mogrify.segment
	sleep 60
done

#montage
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $montage_bin $m122 $k150 $tmp" &>> $ctx/vm1.montage &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $montage_bin $m122 $k150 $tmp" &>> $ctx/vm2.montage
	sleep 60
done

