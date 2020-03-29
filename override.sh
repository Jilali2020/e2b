#!/bin/bash

function printArt(){
		echo -e "\e[32m     ____.__.__      \e[97m   .__  .__          ______\e[31m_______________________"
		echo -e "\e[32m    |    |__|  | ____\e[97m_  |  | |__|         \_   _\e[31m____/\_____  \______   \""
		echo -e "\e[32m    |    |  |  | \__ \e[97m \ |  | |  |  ______  |    \e[31m__)_  /  ____/|    |  _/"
		echo -e "\e[32m/\__|    |  |  |__/ _\e[97m_ \|  |_|  | /_____/  |    \e[31m    \/       \|    |   \""
		echo -e "\e[32m\________|__|____(___\e[97m_  /____/__|         /_____\e[31m__  /\_______ \______  /"
		echo -e "                      \e[97m\/                         \e[31m \/         \/      \/ \e[0m"
		echo -e "\e[0m"
		echo -e "\e[0m"
	
}
clear
printArt
rm -f /etc/enigma2/e2m3u2bouquet/Left1.txt
rm -f /etc/enigma2/e2m3u2bouquet/Right.txt
rm -f /etc/enigma2/e2m3u2bouquet/NewXMLFile.xml
rm -f /etc/enigma2/e2m3u2bouquet/New-ott-sort.xml
prefix=$(cat /etc/enigma2/e2m3u2bouquet/prefix.txt)
cd /etc/enigma2/e2m3u2bouquet/
sed -rn 's/.*<category name="([^"]*)".*/\1/p' $prefix-sort-current.xml > /etc/enigma2/e2m3u2bouquet/Left.txt

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
while [[ 0 != "$prompt" && "$promt" <= $count ]]; do
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

rm /etc/enigma2/e2m3u2bouquet/Left1.txt
rm /etc/enigma2/e2m3u2bouquet/Right.txt
rm /etc/enigma2/e2m3u2bouquet/prefix.txt
