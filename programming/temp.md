
```bash
import urllib2
from time import gmtime, strftime
import time

def check():
        try:
                tm = strftime("%Y-%m-%d %H:%M:%S", gmtime())
                print("time " + tm) 
                urllib2.urlopen('http://www.google.com')
                print("File OK !!")
        except urllib2.HTTPError, e:
                print e.code
while(1):
        time.sleep(5)
        check()
```
