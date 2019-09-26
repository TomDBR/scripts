#!/bin/bash

Last_temp=`/usr/bin/cat /home/Tom/Documents/scripts/lasttemp`
Current_temp=`sensors | grep -o "....°C" | grep -o ".." | head -1`
Current_pwm=`/usr/bin/cat /sys/devices/platform/asus-nb-wmi/hwmon/hwmon1/pwm1`
if [ $Current_temp -le 55 ]; then
	echo '0' > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon1/pwm1
	echo $Current_temp > /home/Tom/Documents/scripts/lasttemp
elif [ $Current_temp -ge 55 ] && [ $Current_temp -le 65 ]; then
	echo '80' > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon1/pwm1
	echo $Current_temp > /home/Tom/Documents/scripts/lasttemp
elif [ $Current_temp -ge 70 ] && [ $Current_temp -le 75 ]; then
	echo '150' > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon1/pwm1
	echo $Current_temp > /home/Tom/Documents/scripts/lasttemp
else
	echo '255' > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon1/pwm1
	echo $Current_temp > /home/Tom/Documents/scripts/lasttemp
fi
echo $Current_temp > /home/Tom/Documents/scripts/lasttemp
