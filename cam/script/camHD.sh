sudo raspistill -vf -hf -w 2000 -h 1333 -o /home/xxx/cam.jpg
sudo cp /home/xxx/cam.jpg /var/www/html/cam.jpg
sudo cp /home/xxx/cam.jpg /home/xxx/save/`date +%y%m%d-%H%M%S`.jpg
scp /home/xxx/cam.jpg xxx@192.168.0.xx:/home/xxx/disk1/`date +%y%m%d-%H%M%S`.jpg
sudo /usr/bin/find /home/xxx/save/* -mtime +0 -delete
