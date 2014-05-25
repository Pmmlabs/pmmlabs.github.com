#!/bin/bash
q="\\\\";
>result.tex
awk 'BEGIN { oq="{"
	     eq="}"
             print "\documentclass" oq "article" eq "\n",
	     "\\begin" oq "document" eq "\n",
	     "\\begin" oq "table" eq "\n",
	     "\\begin" oq "tabular" eq oq "c c" eq}' >> result.tex


Names=$(awk -F ":" '$4!~/^$/ {if(a[$4]++ ==0) print $4}'  /etc/group );
for i in $Names;
do
printf "Username: & $i$q$q\nGroups:$q$q\n" >> result.tex
  awk -F ":" -v username=$i '{if(username == $4)print $1 " & " " ""\\\\"}' /etc/group | sort >> result.tex
  printf "$q$q\n" >> result.tex
done

awk ' BEGIN { oq="{"
	      eq="}"
	      print "\\end" oq "tabular" eq "\n",
	            "\\end" oq "table" eq "\n",
		    "\\end" oq "document" eq }' >> result.tex
pdflatex result.tex
