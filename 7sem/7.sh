#!/bin/bash
# №7. В файле /etc/passwd поменять user на lamer и сохранить в отдельный файл
sed 's/user/lamer/g' /etc/passwd > ./passwd-lamer