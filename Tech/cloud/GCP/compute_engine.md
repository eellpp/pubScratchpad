
### VM , Image and Snapshot
A Virtual Machine (VM) also called "an instance" is an on-demand server that you activate as needed. The underlying hardware is shared among other users in a transparent way and as such becomes entirely virtual to you. You only choose a global geographic location of the instance hosted in one of Google's data center.

A VM is defined by the type of persistent disk and the operating system (OS), such as Windows or Linux, it is built upon. The persistent disk is your virtual slice of hardware.

An image is the physical combination of a persistent disk and the operating system. VM Images are often used to share and implement a particular configuration on multiple other VMs. Public images are the ones provided by Google with a choice of specific OS while private images are customized by users.

A snapshot is a reflection of the content of a VM (disk, software, libraries, files) at a given time and is mostly used for instant backups. The main difference between snapshots and images is that snapshots are stored as diffs, relative to previous snapshots, while images are not.

An image and a snapshot can both be used to define and activate a new VM.

To recap, when you launch a new instance, GCE starts by attaching a persistent disk to your VM. This provides the disk space and gives the instance the root filesystem it requires to boot up. The disk installs the OS associated with the image you have chosen. By taking snapshots of an image, you create instant backups and you can copy data from existing VMs to launch new VMs.

`Example of Deep Learning Images on GCP`   
Specific Deep Learning VM images are available to suit your choice of framework and processor. There are currently images supporting TensorFlow, PyTorch, and generic high-performance computing, with versions for both CPU-only and GPU-enabled workflows.  
https://cloud.google.com/deep-learning-vm/docs/images

### Sharing images between environments
The recommeded approach is to segregate env based on projects. Eg myproject-dev , myproject-prod.  
A dev project image can be shared to prod project  
https://cloud.google.com/compute/docs/images/sharing-images-across-projects#share  

Get the Google APIs service account ( [PROJECT_NUMBER]@cloudservices.gserviceaccount.com) of the project to which the image access is to be provided from IAM. Add this to the current project where image is created and provide access roles.  

Create the instance from the shared image:  
```bash
gcloud compute instances create test-instance --image database-image-a --image-project database-images
```

### Configuring Development and Prod instances while app migration
Imagine you're running a VM instance as part of your web-based application, and are moving from development to production. You can now configure your instance exactly the way you want it and then save your golden config as an instance template. You can then use the template to launch as many instances as you need, configured exactly the way you want. In addition, you can tweak VMs launched from an instance template using the override capability.  
https://cloud.google.com/blog/products/gcp/managing-your-compute-engine-instances-just-got-easier  

### Instance Template
```bash
resource "google_compute_instance_template" "default" {
  name        = "appserver-template"
  description = "This template is used to create app server instances."

  tags = ["foo", "bar"]

  labels = {
    environment = "dev"
  }

  instance_description = "description assigned to instances"
  machine_type         = "n1-standard-1"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = "debian-cloud/debian-9"
    auto_delete  = true
    boot         = true
  }

  // Use an existing disk resource
  disk {
    // Instance Templates reference disks by name, not self link
    source      = "${google_compute_disk.foobar.name}"
    auto_delete = false
    boot        = false
  }

  network_interface {
    network = "default"
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

data "google_compute_image" "my_image" {
  family  = "debian-9"
  project = "debian-cloud"
}

resource "google_compute_disk" "foobar" {
  name  = "existing-disk"
  image = "${data.google_compute_image.my_image.self_link}"
  size  = 10
  type  = "pd-ssd"
  zone  = "us-central1-a"
}
```


