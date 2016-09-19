#!/bin/sh
fichierLog="/home/xxx/`hostname`_`date +%Y-%m-%d`_daily.log"
if [ -f "$fichierLog" ]
then
echo "Fichier trouvé"
else
echo "Fichier non trouvé: création du fichier"
touch "$fichierLog"
fi
