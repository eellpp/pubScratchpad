
### Console SDK 

https://cloud.google.com/sdk/gcloud/reference/config/

```bash
gcloud --help

### view info 
gcloud topic configuration

### current active path
gcloud info --format='get(config.paths.active_config_path)'

```
You can set the 
- default project in the config `core` section of ini file. Or use --project option with commands
- default compute zone and region


