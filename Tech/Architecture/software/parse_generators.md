pydoc Markdown:  
https://pydoc-markdown.readthedocs.io/en/latest/docs/configuration/

The file contains of four main sections:  

**`loaders`**: A list of plugins that load API objects, for example from Python source files. The default configuration defines just a python loader.  
**`processors`**: A list of plugins that process API objects to modify their docstrings (e.g. to adapt them from a documentation format to Markdown or to remove items that should not be rendered into the documentation). The default configuration defines the `filter`, `smart` and `crossref processors` in that order.  
**`renderer`**: A plugin that produces the output files. The default configuration defines the markdown renderer (which by default will render a single file to stdout).  
**`hooks`**: Configuration for commands that will be executed before and after rendering.  
