sudo raspistill -vf -hf -w 1000 -h 666 -o /home/xxx/cam.jpg
sudo cp /home/xxx/cam.jpg /var/www/html/cam.jpg
sudo cp /home/xxx/cam.jpg /home/xxx/save/cam-`date +%s`.jpg
scp /home/xxx/cam.jpg xxx@192.168.0.xx:/home/xxx/disk1/`date +%y%m%d-%H%M%S`.jpg
sudo /usr/bin/find /home/xxx/save/* -mtime +0 -delete
