#!/bin/bash
# 3. Найти в текущей директории все исполняемые файлы, являющиеся shell-скриптами, т.е. начинающиеся с имени оболочки.
for a in $(find . -type f)
do 
    if [ head -1 $a | grep "^#!/bin/bash" ] && [ -x $a ]
    then echo $a
    fi
done