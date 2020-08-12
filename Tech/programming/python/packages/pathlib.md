https://treyhunner.com/2018/12/why-you-should-be-using-pathlib/  
https://treyhunner.com/2019/01/no-really-pathlib-is-great/  


### Joining Path
```bash
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
TEMPLATES_DIR = BASE_DIR.joinpath('templates')
``` 

### Reading Files
```python
from pathlib import Path

file_contents = [path.read_text() for path in Path.cwd().rglob('*.py')]

```

### Writing files
```python
Path('.editorconfig').write_text('# config goes here')

path = Path('.editorconfig')
with open(path, mode='wt') as config:
    config.write('# config goes here')
```
