#!/bin/bash
str=();

while IFS=: read -r Groups Tmp1 Tmp2 Username
do
  if [ $Username!="" ] && ! [[ "${str[*]}" =~ "$Username" ]];
  then
    str+=($Username);
  fi;
done < /etc/group

for X in "${str[@]}"
do
  echo ""
  echo "Username: $X"
  echo "Groups:"
  while IFS=: read -r Groups Tmp1 Tmp2 Username
  do
    if [ "$Username" == "$X" ];
    then
      echo "$Groups"
    fi;
  done < /etc/group
done

