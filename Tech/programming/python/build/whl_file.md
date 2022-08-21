A Python .whl file is essentially a ZIP (.zip) archive with a specially crafted filename that tells installers what Python versions and platforms the wheel will support.

A wheel is a type of built distribution. In this case, built means that the wheel comes in a ready-to-install format and allows you to skip the build stage required with source distributions.

A wheel filename is broken down into parts faq:

{dist}-{version}(-{build})?-{python}-{abi}-{platform}.whl


### Install setuptools and wheels package  
pip install setuptools wheel

### Creating Whl file

python setup.py bdist_wheel


### References
https://realpython.com/python-wheels/  

https://packaging.python.org/tutorials/packaging-projects/  

