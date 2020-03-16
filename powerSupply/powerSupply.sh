dateHome=`stat -c %Y ./fileTest`
now=`date +%s`

diff=$(($now-$dateHome))

delay=1800

echo dateHome: $dateHome
echo now: $now
echo diff: $diff

if [ $diff -gt $delay ]
        then
                echo "Plus grand"
        else
                echo "Plus petit"
fi

