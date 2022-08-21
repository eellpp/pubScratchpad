conda is a package manager. Anaconda is the distribution.   
conda can be installed separately from anaconda.  
conda can be compared to pip + virtualenv  


### Conda repo vs pypi repo
pypi repo is the python repo containing all python packages. However it is not guaranteed to have all platform specific package version. Especially windows  
conda repo contains python repo for all major environments  


### create env with specific python version using custom channel
conda create -y -n py36 python=3.6 --channel <path to custom channel> --override-channel

### create dev env
conda create --name dev

source activate <env name>

### Reusing enviroments
conda env export > environment.yml  
conda env create -f environment.yml 

conda should fetch the package mapping to conda or pypi channels


### List Env
conda env list

### Get info on conda env
conda info --env  
conda config --get-channels

### search within a channel
conda search --channel <channel url> <package_name>

## Conda Config File
The conda configuration file, .condarc, is an optional runtime configuration file that allows advanced users to configure various aspects of conda, such as which channels it searches for packages, proxy settings, and environment directories. 

### Condarc path
condarc file is frequently found in:  
- macOS: /Users/Username.  
- Linux: ~/. condarc.  
- Windows: C:\Users\Username.  

Example config file  
https://docs.conda.io/projects/conda/en/latest/configuration.html

```bash
default_channels:

ssl_verify: false
```

