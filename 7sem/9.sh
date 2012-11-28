#!/bin/bash
# Создать скрипт, который может:
# запускать службу, останавливать службу, отчитываться
# по команде status о том, выполняется ли служба в данный момент.
# Не запускать службу повторно, если она уже запущена.
# Служба - программа netcat (nc), запущенная на прослуживание TCP-порта 6000.
pidfile="netcat.pid" # вообще должно быть /var/run/netcat.pid
command="/home/mline/netcat-0.7.1/distr/bin/netcat -l -p 6000" # если есть доступ к неткату по команде nc, то лучше её использовать
case "$1" in
  start)
    if  [ -f $pidfile ]
    then echo "Служба уже запущена!"
    else 
	$command </dev/null  & 
	echo $! > $pidfile
        echo "Готово!"
    fi
 ;;
   stop)
    if [ -f $pidfile ]
    then
	kill `cat $pidfile` > /dev/null
	if ps | grep `cat $pidfile` | grep -v grep
	then echo "Неудачная попытка остановки службы!"
	else
    		echo "Готово!"
	        rm $pidfile
	fi
    else 
    echo "Нечего останавливать!"
    fi
 ;;
 status)
    if [ -f $pidfile ]
    then
    echo "Служба запущена, PID: "
    cat $pidfile
    else echo "Служба остановлена"
    fi
 ;;
esac
