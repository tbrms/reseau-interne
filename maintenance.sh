#!/bin/sh

fichierLog="`hostname`_`date +%Y-%m-%d`.log"

if [ -f "$fichierLog" ]
then
	echo "Fichier trouvé"
else
	echo "Fichier non trouvé: création du fichier"
	touch "$fichierLog"
fi

echo "*************************************************" > "$fichierLog"
echo "        Rapport de `hostname` du `date +%Y-%m-%d`" >> "$fichierLog"
echo "*************************************************" >> "$fichierLog"
echo "\n" >> "$fichierLog"
echo "Mises à jour logicielles" >> "$fichierLog"
echo "------------------------" >> "$fichierLog"


apt-get update 1>/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
	echo "update \t\t [OK]" >> "$fichierLog"
else
	echo "update \t\t [KO]" >> "$fichierLog"
fi

apt-get upgrade -y 1>/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
	echo "upgrade \t [OK]" >> "$fichierLog"
else
	echo "upgrade \t [KO]" >> "$fichierLog"
fi

apt-get dist-upgrade -y 1>/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
	echo "dist-upgrade \t [OK]" >> "$fichierLog"
else
	echo "dist-upgrade \t [KO]" >> "$fichierLog"
fi

ntp  1>/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
	echo "NTP \t\t [OK]" >> "$fichierLog"
else
	echo "NTP \t\t [KO]" >> "$fichierLog"
fi


echo "\n" >> "$fichierLog"
echo "Espace memoire" >> "$fichierLog"
echo "------------------------" >> "$fichierLog"

d01="/dev/sda1"
echo "`df -h | grep $d01 | awk '{ print $1}'` \t occupation: `df -h | grep $d01 | awk '{ print $5}'` \t memoire restante: `df -h | grep $d01 | awk '{ print $4}'`" >> "$fichierLog"
