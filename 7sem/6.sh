#!/bin/bash
# №6. Создать в папке исполняемый файл с правами: группа dialout - выполнение кроме пользователя user.
# Создать папку так, чтобы user не мог посмотреть имена файлов в папке, но мог запустить оттуда файл.
touch somefile
chown user:dialout somefile
chmod g+x,u-x somefile

mkdir somedir
chown user somedir
chmod u-r,u+x somedir