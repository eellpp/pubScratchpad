Sys Log Monitoring

sudo apt-get install logwatch  

Create a directory the Logwatch package in the repositories currently does not create, but is required for proper operation:  
$ sudo mkdir /var/cache/logwatch  

Configuration shouldn't be edited in the install directory (/usr/share/logwatch). Copy logwatch.conf to /etc/logwatch before editing:  
$ sudo cp /usr/share/logwatch/default.conf/logwatch.conf /etc/logwatch/conf/  

Edit logwatch.conf to put in the e-mail where you want the report sent:  
MailTo = me@example.com  

### Generating report in file with date pattern 
If you want logwatch to create a file in html format then edit logwatch.conf and make changes as below  
Output  = file  
Format = Html  


mkdir /var/cache/logwatch/

Testing:  
/usr/sbin/logwatch --output file --filename /var/cache/logwatch/$(date +%Y%m%d)-logwatch.txt

/usr/sbin/logwatch --detail 10 --range today --service http --service postfix --service zz-disk_space --format html --output file --filename /var/cache/logwatch/$(date +%Y%m%d)-logwatch.txt

#### cron job 
The default cron job for logwatch is at:  
/etc/cron.daily/00logwatch  



