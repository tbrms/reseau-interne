sudo raspistill -vf -hf -w 1000 -h 666 -o /home/xxx/cam.jpg
sudo cp /home/xxx/cam.jpg /var/www/html/cam.jpg
sudo cp /home/xxx/cam.jpg /home/xxx/save/cam-`date +%s`.jpg
sudo /usr/bin/find /home/xxx/save/* -mtime +0 -delete
