#!/bin/sh

disp_sec=30

photo_path='/home/pi/Pictures/frame_pictures'

permanent_path='/home/pi/Pictures/frame_pictures/Permanent'

rclone_path='remote:/Trivedi_Parmar'

rclone_permanent='remote:/Trivedi_Parmar/Permanent'

# check if permanent folder has any files in it
output1="$(rclone size $rclone_permanent | head -1)"
echo $output1
if [ "$output1" = "Total objects: 0" ]
then
echo "Permanent Off"

# if permanent fold is empty then go to randon 30 second pictuer frame mode

if /usr/bin/rclone check --size-only $rclone_path $photo_path
then
if ps -A | grep feh
then
echo "on"
else
sudo DISPLAY=:0.0 XAUTHORITY=/home/pi/.Xauthority /usr/bin/feh -F -Z -z -Y -D$disp_sec $photo_path --auto-rotate
fi
echo "no diff"
else
echo "diff"
/usr/bin/rclone -v sync $rclone_path $photo_path 
if ps -A | grep feh
then
feh_ID=$(pidof feh)
sudo kill -9 $feh_ID
sudo DISPLAY=:0.0 XAUTHORITY=/home/pi/.Xauthority /usr/bin/feh -F -Z -z -Y -D$disp_sec $photo_path --auto-rotate
else
sudo DISPLAY=:0.0 XAUTHORITY=/home/pi/.Xauthority /usr/bin/feh -F -Z -z -Y -D$disp_sec $photo_path --auto-rotate
fi
fi

else
echo "Permanent On"
# if permanent folder is not empty then display only first file in permanent folder

if /usr/bin/rclone check --size-only $rclone_path $photo_path 
then
if ps -A | grep feh
then
echo "on"
else
sudo DISPLAY=:0.0 XAUTHORITY=/home/pi/.Xauthority /usr/bin/feh -F -Z -Y $permanent_path --auto-rotate
fi
echo "no diff"
else
echo "diff"
/usr/bin/rclone -v sync $rclone_path $photo_path
if ps -A | grep feh
then
feh_ID=$(pidof feh)
sudo kill -9 $feh_ID
sudo DISPLAY=:0.0 XAUTHORITY=/home/pi/.Xauthority /usr/bin/feh -F -Z -Y $permanent_path --auto-rotate
else
sudo DISPLAY=:0.0 XAUTHORITY=/home/pi/.Xauthority /usr/bin/feh -F -Z -Y $permanent_path --auto-rotate
fi
fi
fi
