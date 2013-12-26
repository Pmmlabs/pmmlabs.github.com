function whois() 
#Вызов: whois <идентификаторы пользователя> 
{
  #Проверка на наличие корректных параметров (к-во аргументов ком. строки меньше 1)
  if [ $# -lt 1 ] ; then
    echo "whois : need user id, please"
    return 1
  fi

  #Для каждого параметра ком строки
  for loop
  do
    #Стараемся найти имя пользователя с идентификатором $loop
    _USER_NAME=`grep ^$loop":" /etc/passwd | awk -F: '{print $5}' | awk -F, '{print $1}'`;
    if [ "$_USER_NAME" = "" ]; then
      echo "whois : sorry, cannot find $loop"
    else
      echo "$loop is $_USER_NAME"
    fi
  done    
}
whois "$1"