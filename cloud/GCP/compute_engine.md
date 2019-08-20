
### VM , Image and Snapshot
A Virtual Machine (VM) also called "an instance" is an on-demand server that you activate as needed. The underlying hardware is shared among other users in a transparent way and as such becomes entirely virtual to you. You only choose a global geographic location of the instance hosted in one of Google's data center.

A VM is defined by the type of persistent disk and the operating system (OS), such as Windows or Linux, it is built upon. The persistent disk is your virtual slice of hardware.

An image is the physical combination of a persistent disk and the operating system. VM Images are often used to share and implement a particular configuration on multiple other VMs. Public images are the ones provided by Google with a choice of specific OS while private images are customized by users.

A snapshot is a reflection of the content of a VM (disk, software, libraries, files) at a given time and is mostly used for instant backups. The main difference between snapshots and images is that snapshots are stored as diffs, relative to previous snapshots, while images are not.

An image and a snapshot can both be used to define and activate a new VM.

To recap, when you launch a new instance, GCE starts by attaching a persistent disk to your VM. This provides the disk space and gives the instance the root filesystem it requires to boot up. The disk installs the OS associated with the image you have chosen. By taking snapshots of an image, you create instant backups and you can copy data from existing VMs to launch new VMs.
