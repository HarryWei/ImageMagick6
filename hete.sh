#!/bin/bash
#
# Weiwei Jia <harryxiyou@gmail.com> (Bash) 2018
#
kvm1="kvm1"
kvm2="kvm1"
ip1="192.168.122.96"
ip2="192.168.122.98"
ctx=$2

#mount disk
#ssh $kvm1@$ip1 "/home/$kvm1/vMigrater/scripts/mount.sh"
#ssh $kvm2@$ip2 "/home/$kvm2/vMigrater/scripts/mount.sh"

HOME_DIR="/home/kvm1/workshop/vPair/apps/ImageMagick6/utilities"
compare_bin="$HOME_DIR/compare"
convert_bin="$HOME_DIR/convert"
mogrify_bin="$HOME_DIR/mogrify"
montage_bin="$HOME_DIR/montage"
122m="$HOME_DIR/122m.jpg"
78m="$HOME_DIR/78m.jpg"
150k="$HOME_DIR/150k.jpg"
tmp="$HOME_DIR/tmp.jpg"

#compare
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.compare &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $compare_bin $122m $150k $tmp" &>> $ctx/vm1.compare
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $compare_bin $122m $150k $tmp" &>> $ctx/vm2.compare
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5

#compare channel_red
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.compare.channel_red &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $compare_bin -channel red -metric PSNR $122m $150k $tmp" &>> $ctx/vm1.compare.channel_red
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $compare_bin -channel red -metric PSNR $122m $150k $tmp" &>> $ctx/vm2.compare.channel_red
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5

#compare compose
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.compare.compose &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $compare_bin -compose src $122m $150k $tmp" &>> $ctx/vm1.compare.compose
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $compare_bin -compose src $122m $150k $tmp" &>> $ctx/vm2.compare.compose
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5

#convert edge_detect
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.convert.edge_detect &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $122m -colorspace Gray  -edge 1 -negate $tmp" &>> $ctx/vm1.convert.edge_detect
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $122m -colorspace Gray  -edge 1 -negate $tmp" &>> $ctx/vm2.convert.edge_detect
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5

#convert blur
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.convert.blur &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $122m -blur 0x8 $tmp" &>> $ctx/vm1.convert.blur
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $122m -blur 0x8 $tmp" &>> $ctx/vm2.convert.blur
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5

#convert charcoal_effect
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.convert.charcoal &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $122m -charcoal 3 $tmp" &>> $ctx/vm1.convert.charcoal
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $122m -charcoal 3 $tmp" &>> $ctx/vm2.convert.charcoal
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5

#convert draw
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.convert.draw &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin -size 15360x8640 gradient:green-yellow $tmp" &>> $ctx/vm1.convert.draw
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin -size 15360x8640 gradient:green-yellow $tmp" &>> $ctx/vm2.convert.draw
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5

#convert paint_effect
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.convert.paint_effect &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $122m -morphology CloseI Disk:2.5 $tmp" &>> $ctx/vm1.convert.paint_effect
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $122m -morphology CloseI Disk:2.5 $tmp" &>> $ctx/vm2.convert.paint_effect
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5

#convert sharpen
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.convert.sharpen &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $122m -sharpen 0x1 $tmp" &>> $ctx/vm1.convert.sharpen
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $122m -sharpen 0x1 $tmp" &>> $ctx/vm2.convert.sharpen
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5

#convert fft
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.convert.blur &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $122m -fft +depth +adjoin $tmp" &>> $ctx/vm1.convert.blur
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $122m -fft +depth +adjoin $tmp" &>> $ctx/vm2.convert.blur
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5

#convert shear
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.convert.shear &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $convert_bin $122m -background Blue  -shear 20x0 $tmp" &>> $ctx/vm1.convert.shear
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $convert_bin $122m -background Blue  -shear 20x0 $tmp" &>> $ctx/vm2.convert.shear
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5

#mogrify resize
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.mogrify.resize &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $mogrify_bin -resize 150% $122m" &>> $ctx/vm1.mogrify.resize
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $mogrify_bin -resize 150% $122m" &>> $ctx/vm2.mogrify.resize
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5

#mogrify segment
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.mogrify.segment &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $mogrify_bin -segment 128000x60 $78m" &>> $ctx/vm1.mogrify.segment
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $mogrify_bin -segment 128000x60 $78m" &>> $ctx/vm2.mogrify.segment
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5

#compare
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> $ctx_oltp/vm2.montage &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $montage_bin $122m $150k $tmp" &>> $ctx/vm1.montage
	#ssh $kvm2@$ip2 "time taskset -c 0-22 $montage_bin $122m $150k $tmp" &>> $ctx/vm2.montage
	#sleep 10
done
ssh $kvm2@$ip2 "killall accurate_cpu"
sleep 5
