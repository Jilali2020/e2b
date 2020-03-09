echo ""
echo "> Even geduld  ... licht update"
opkg update  &>/dev/null

echo ""
echo "> Installatie Bash... in plaats van Shell"
if opkg list_installed bash* | grep "bash*" &>/dev/null
then
echo "> Bash al geinstalleerd!"
else
opkg install bash &>/dev/null
fi

wget -q https://raw.githubusercontent.com/Jilali2020/e2b/master/e2b.sh -O /tmp/install.sh
chmod 777 /tmp/install.sh
/tmp/install.sh

rm ./install.sh

exit
