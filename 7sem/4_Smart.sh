#!/bin/bash
# Вывести список используемых для входа шеллов из /etc/passwd, 
# вывести для каждого количество повторений, а также первого по алфавиту 
# пользователя, использующего шелл
# 
# (Обязательные условие: Применение AWK для обработки текста, LaTeX для верстки.
# Задача 4 делается при помощи AWK, при этом конечный результат при помощи 
# latex выводится в PDF-файл.)
awk -F: '
BEGIN {
  shellcount=0 #Общее кол-во шеллов (их еще нет)
}

{
  existnewshell=0;                    #Считаем, что будет новый шелл
  for(i=0;i<shellcount;i++) {         #Идем по списку уже сохраненных шеллов
    if (shells[i]==$7) {              #Если данный шелл уже использовался
      shellscounter[i]=shellscounter[i]+1;     #Увеличиваем количество использований
      if ($1<shelluser[i]) #Если меньший по алфавиту пользователь использовал шелл
        shelluser[i]=$1 #Сохранеяем его 
      existnewshell=-1 #Шелл не стоит добавлять в список испозьзуемых
    }
  }
  if (existnewshell==0) { #Если шелл не найден в списке уже сохраненных, его надо сохранить
    shells[shellcount]=$7           #Название шелла
    shellscounter[shellcount]=1     #По-умолчанию, количество повторений = 1
    shelluser[shellcount]=$1        #Имя текущего пользователя, использующего шелл
    shellcount++                    #Увеличиваем на 1 общее кол-во шеллов
  }
} 
END {
  for(i=0;i<shellcount;i++) {
    print shells[i]"\t"shellscounter[i]"\t"shelluser[i]"\n"
  } 
} ' /etc/passwd > document;
echo '\documentclass[a4paper,12pt]{article}
\\begin{document}' > result.tex;
cat document >> result.tex;
echo '\end{document}' >> result.tex;
pdflatex result.tex;