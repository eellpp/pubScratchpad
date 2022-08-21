setup.py is the build script for setuptools. It tells setuptools about your package (such as the name and version) as well as which code files to include.

```bash

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="example-pkg-YOUR-USERNAME-HERE", # Replace with your own username
    version="0.0.1",
    author="Example Author",
    author_email="author@example.com",
    description="A small example package",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/pypa/sampleproject",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',
)
```

### Adding non code files

Often packages will need to depend on files which are not .py files: e.g. images, data tables, documentation, etc. Those files need special treatment in order for setuptools to handle them correctly.

The mechanism that provides this is the MANIFEST.in file.   
This is relatively quite simple: MANIFEST.in is really just a list of relative file paths specifying files or globs to include.:
```bash
include README.rst
include docs/*.txt
include funniest/data.json
```

In order for these files to be copied at install time to the package’s folder inside site-packages, you’l need to supply 
`include_package_data=True`

https://setuptools.readthedocs.io/en/latest/setuptools.html#including-data-files  

### References
https://packaging.python.org/tutorials/packaging-projects/  
