### ### pip and conda
Use conda for environment management. Within the environment use pip to install the packages  
Use conda to create a env with specific python version.  

https://www.anaconda.com/blog/understanding-conda-and-pip  

### config files
conda config file is .condarc  
pip config file pip.conf  

### PIP  example config file
```bash
[global] 
default-timeout = 60
respect-virtualenv = true 
download-cache = ~/.pip/cache 
log-file = ~/.pip/pip.log 


[global]
timeout = 10
index-url = http://pypi.douban.com/simple 
trusted-host = pypi.douban.com
find-links = 
        http://mirror1.example.com 
        http://mirror2.example.com
```

### Command line options
-i index url : Can only be one index url 
-f find links : multiple links  
—extra-index-url : These are extra index urls.   
-I : ignore installed and overwrite them  
- r install from requirements file  

### Index-url vs find-links in config file
index-url can be considered a page with nothing but packages on it. You're telling pip to find what you want to install on that page; and that page is in a predictable format as per PEP 503. The index will only list packages it has available.
find-links is an array of locations to look for certain packages. You can pass it file paths, individual URLs to TAR or WHEEL files, HTML files, git repositories and more.  

### Requirements file
Requirements files are used to hold the result from pip freeze for the purpose of achieving repeatable installations. 
pip freeze > requirements.txt  
pip install -r requirements.txt  

### Wheel file
“Wheel” is a built, archive format that can greatly speed installation compared to building and installing from source archives. pip prefers Wheels where they are available.   

pip install <path to whl file>  

pip uninstall SomePackage  

### Location of Config File
https://pip.pypa.io/en/stable/user_guide/#configuration  
* On Unix the default configuration file is: $HOME/.config/pip/pip.conf which respects the XDG_CONFIG_HOME environment variable.  
* On macOS the configuration file is $HOME/Library/Application Support/pip/pip.conf if directory $HOME/Library/Application Support/pip exists else $HOME/.config/pip/pip.conf.  
* On Windows the configuration file is %APPDATA%\pip\pip.ini.  
There are also a legacy per-user configuration file which is also respected, these are located at:  
* On Unix and macOS the configuration file is: $HOME/.pip/pip.conf  
* On Windows the configuration file is: %HOME%\pip\pip.ini  
