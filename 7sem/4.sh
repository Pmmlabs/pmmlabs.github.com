#!/bin/bash
# Найти в /etc/fstab точки монитрования только реальных устройств и 
# для их опций вывести описания взяв их из man mount
cat /etc/fstab | awk '{ if ($1 !~ /(tmpfs|devpts|sysfs|proc|devfs|#)/) print "точка монитрования: " $2 " опции: " $4 }'
for i in `cat /etc/fstab | awk '{ if ($1 !~ /(tmpfs|devpts|sysfs|proc|devfs|#)/) print $4 }'`
 do
  IFS=","
  for opt in $i
   do
     echo "Описание опции "$opt":"
     gzip -cd /usr/share/man/man8/mount.8.gz | awk 'BEGIN{ RS=".TP"}{if ($2 == "'$opt'"){ $1=""; $2=""; print $0; exit}}'
   done
 done