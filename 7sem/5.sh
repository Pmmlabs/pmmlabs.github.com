# Написать скрипт : 1. проверка наличия привилегий root
# 2. для заданного iso $1  и точки монтирования $2 - если примонтировано - отмонтировать,
# иначе примонтировать в эту точку
if id | grep "^uid=0(root)" > /dev/null
 then 
  if mount | grep "on "$2 > /dev/null
   then 
    umount $2
    echo "Отмонтировано!"
   else 
    mount -o loop $1 $2
    echo "Примонтировано!"
  fi 
 else echo "Вы не root"
fi