#!/bin/bash

rm -f Left1.txt
rm -f Right.txt
rm -f NewXMLFile.xml
rm -f New-ott-sort.xml
prefix=$(cat /etc/enigma2/e2m3u2bouquet/prefix.txt)
sed -rn 's/.*<category name="([^"]*)".*/\1/p' $prefix-sort-current.xml > Left.txt

while IFS= read -r line; do
    count=$(($count+1))	
    printf "$count-$line\n" >> Left1.txt
done < Left.txt

rm Left.txt

while IFS= read -r line; do
    count=$(($count+1))	
    printf "$line\n"
done < Left1.txt


read -p "Sorteer door nummer in te geven of druk 0 voor bewerken: " prompt
while [ 0 != "$prompt" ] ; do
  count1=$(($count1+1))	
  string=$(grep "^$prompt-" Left1.txt)
  removestring="$prompt-"
  name=${string//$removestring/}
  echo "$count1-$name" >> Right.txt
  grep -v "^$prompt-" Left1.txt > imd.txt
  rm Left1.txt
  cat imd.txt > Left1.txt
  rm imd.txt
  cat Right.txt
  read -p "Sorteer door nummer in te geven of druk 0 voor bewerken:" prompt
done

echo "Even geduld nieuwe sorteerde XML aan het voorbereiden ..."

customtext=$(echo -e "<categories>\n" )
while IFS= read -r line; do
    count2=$(($count2+1))	
    removestring="$count2-"
    name=${line//$removestring/}
    customtext+=$(echo -e "<category name=\"$name\" nameOverride=\"\" enabled=\"true\" customCategory=\"false\"/>\n")  
done < Right.txt

while IFS= read -r line; do	
    name=$(echo "$line" |sed 's/.*-//g')
    customtext+=$(echo -e "<category name=\"$name\" nameOverride=\"\" enabled=\"true\" customCategory=\"false\"/>\n")
done < Left1.txt


cat $prefix-sort-current.xml > $prefix-sort-override.xml

customtext+="</categories>\\"

sed -i '\%<categories>%,\%</categories>%c\ '"$customtext"'' $prefix-sort-override.xml

rm Left1.txt
rm Right.txt
