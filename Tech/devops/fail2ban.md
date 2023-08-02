https://github.com/fail2ban/fail2ban

fail2ban is configured to monitor the logs of a service, it read the logs file and try to match failregex defined in the filter file. The filter is designed to identify authentication failures for that specific service through the use of regular expressions. When the failregex was found maxretry times in the log file action  is triggered.  

By default, action will be taken when 3 authentication failures have been detected in 10 minutes, and the default ban time is for 10 minutes. The default for number of authentication failures necessary to trigger a ban is overridden in the SSH portion of the default configuration file to allow for 6 failures before the ban takes place. This is entirely configurable by the administrator in the jail.conf file  


### Viewing banned IP's
At the simplest logging level, entries will appear in /var/log/fail2ban.log . You will require sudo access .  


### Banning custom error code generated on specific pages 
Example for / page generate custom error code  
```bash
@app.route('/')
def empty_view(self):
    content = {'please move along': 'nothing to see here'}
    return content, status.HTTP_410_GONE
```
Put nginx in front of your flask app and use a fail2ban config to watch for this error code and start banning ips that are constantly hitting these urls  

```bash
# Fail2Ban configuration file
[Definition]
failregex = <HOST> - - \[.*\] "(GET|POST).*HTTP.* 410
ignoreregex =
```

### AS an alternative to fail-to-ban: 
- disable password authentication 
- use strong keys

### Security Alerts/bug in library
Fail2ban – Remote Code Execution (securitum.com)  
https://news.ycombinator.com/item?id=28679761
