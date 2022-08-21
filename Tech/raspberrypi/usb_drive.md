https://turbofuture.com/computers/Permanently-Mounting-a-USB-Harddrive-to-your-Raspberry-Pi  

sudo fdisk -l
```bash
#You should see something like this
Disk /dev/mmcblk0: 4110 MB, 4110417920 bytes
4 heads, 16 sectors/track, 125440 cylinders, total 8028160 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000b5098
        Device Boot      Start         End      Blocks   Id  System
/dev/mmcblk0p1            8192      122879       57344    c  W95 FAT32 (LBA)
/dev/mmcblk0p2          122880     8028159     3952640   83  Linux
Note: sector size is 4096 (not 512)
Disk /dev/sda: 4000.8 GB, 4000787025920 bytes
255 heads, 63 sectors/track, 60800 cylinders, total 976754645 sectors
Units = sectors of 1 * 4096 = 4096 bytes
Sector size (logical/physical): 4096 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x90a334b0
   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048   976754644  3907010388    7  HPFS/NTFS/exFAT
```

Disk /dev/sda 4000.0 GB"  
And has one partition:  

"/dev/sda1"  
Remember that. "/dev/sda1" That is the name that the drive is going by and the name we'll use to mount it.  

Creating a Mount Point  
```bash
#Type this line then press enter
sudo mkdir /media/pidrive
#Then type this line and press enter
sudo chown pi:pi /media/pidrive
```

```bash
# check if pi can see the disk
sudo fdisk -l 
# get the UUID  
sudo blkid 
UUID="A93E-1C09"   
# open fstab
sudo vi /etc/fstab   
UUID=A93E-1C09 /media/seagate vfat defaults,nofail 0 0
 
 ## check if mounted correctly
 sudo mount -a
 ```
