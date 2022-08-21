
## Workflow
terraform init  
terraform plan  
terraform apply   


### hcloud documentation
https://docs.hetzner.cloud/#overview-getting-started  

### Awsome hcloud
https://github.com/hetznercloud/awesome-hcloud

### hcloud-python  
https://github.com/hetznercloud/hcloud-python


### Terraform Hetzner
https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs

Set up infrastructure in Hetzner Cloud using Terraform  
https://medium.com/@orestovyevhen/set-up-infrastructure-in-hetzner-cloud-using-terraform-ce85491e92d  
https://github.com/awesome-nick/tf-hetzner-example  

While using terraform, generate the plan and confirm it and then use the provide the plan file to apply.  
This way you are applying the exact plan that you have inspected.  

```bash
terraform plan -var='hcloud_token=<YOUR-API-TOKEN-HERE>' -out tfplan
```
This will save the plan in binary format in file tfplan

```bash
terraform show tfplan  
```
This will output the plan in human readable format

You can use the optional -out=FILE option to save the generated plan to a file on disk, which you can later execute by passing the file to terraform apply as an extra argument. This two-step workflow is primarily intended for when running Terraform in automation.  

terraform apply tfplan  


#### Destroy
terraform destroy -var='hcloud_token=<YOUR-API-TOKEN-HERE>'
