Домашнее задание №3:
========================
Работа с LVM
-------------------------

**_на имеющемся образе /dev/mapper/VolGroup00-LogVol00 38G 738M 37G 2% /_**


#### 1) уменьшить том под / до 8G:
___

```bash
sudo pvcreate /dev/sd{b,c,d}
sudo vgcreate vg0 /dev/sdc /dev/sdb /dev/sdd
sudo lvcreate -l 100%FREE -n roottemp vg0
sudo vgscan
sudo vgchange -ay
sudo mkfs.xfs /dev/vg0/roottemp
sudo mount /dev/mapper/vg0-roottemp /mnt/
sudo dnf install xfsdump
sudo xfsdump -f /tmp/rootdump /dev/mapper/VolGroup00-LogVol00
sudo xfsrestore -f /tmp/rootdump /mnt/
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
````

После этого, подправил _/boot/grub2/grub.cfg_.
Для того что бы грузиться по умолчанию с __/dev/mapper/vg0-roottemp__

_______________

...
linux16 /vmlinuz-3.10.0-693.21.1.el7.x86_64 __root=/dev/mapper/vg0-roottemp__ ro
no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0
crashkernel=auto __rd.lvm.lv=vg0/roottemp__ rd.lvm.lv=VolGroup00/LogVol01 rhgb quiet
...

_______________

После перезагрузки, смотрим где размещается __/__
````
sudo lsblk
NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                       8:0    0   40G  0 disk
├─sda1                    8:1    0    1M  0 part
├─sda2                    8:2    0    1G  0 part /boot
└─sda3                    8:3    0   39G  0 part
  ├─VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]
  └─VolGroup00-LogVol00 253:2    0 37.5G  0 lvm
sdb                       8:16   0  250M  0 disk
└─vg0-roottemp          253:0    0  4.1G  0 lvm  /
sdc                       8:32   0  2.5G  0 disk
└─vg0-roottemp          253:0    0  4.1G  0 lvm  /
sdd                       8:48   0  1.5G  0 disk
└─vg0-roottemp          253:0    0  4.1G  0 lvm  /
````
Все отлично.
Теперь осталось удалить старый раздел который занимает весь LVM и создать новый.

````
sudo lvremove /dev/VolGroup00/LogVol00
sudo lvcreate -L 8G -n root VolGroup00
sudo mkfs.xfs /dev/mapper/VolGroup00-root
sudo vgscan
sudo vgchange -ay
sudo xfsdump -f /tmp/rootdump /dev/vg0/roottemp
sudo mount /dev/VolGroup00/root /mnt/
sudo xfsrestore -f /tmp/rootdump /mnt/
````
Снова правим __grub.cfg__
_______________

...
linux16 /vmlinuz-3.10.0-693.21.1.el7.x86_64 __root=/dev/mapper/VolGroup00-root__ ro
no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0
crashkernel=auto __rd.lvm.lv=VolGroup00/root__ rd.lvm.lv=VolGroup00/LogVol01 rhgb quiet
...

_______________
А так же сразу поправим fstab который находится в директории __/mnt/etc/fstab__
_______________
/dev/mapper/VolGroup00-root     /                       xfs     defaults        0 0
~~#/dev/mapper/VolGroup00-LogVol00 /                       xfs     defaults        0 0~~
_______________

Перезагружаемся. 
````
NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                       8:0    0   40G  0 disk 
├─sda1                    8:1    0    1M  0 part 
├─sda2                    8:2    0    1G  0 part /boot
└─sda3                    8:3    0   39G  0 part 
  ├─VolGroup00-root     253:0    0    8G  0 lvm  /
````
Задание __выполнено__.

2) выделить том под /home
````
sudo lvcreate -L 8G -n home VolGroup00
sudo mkdir /tmp/home
sudo cp -ra /home/* /tmp/home/
sudo mkfs.ext4 /dev/mapper/VolGroup00-home
sudo mount /dev/mapper/VolGroup00-home /home
sudp cp -ra /tmp/home/* /home/
````
Задание __выполнено__.

3) выделить том под /var
````
sudo lvcreate -L 8G -n var VolGroup00
sudo mkfs.ext4 /dev/mapper/VolGroup00-var
sudo mkdir  /tmp/var
sudo cp -ra /var/* /tmp/var/
sudo mount /dev/mapper/VolGroup00-var /var
udo cp -ra /tmp/var/* /var/
````

4) /var - сделать в mirror
5) /home - сделать том для снэпшотов
Сгенировал, кучку файлов в __/home/vagrant__ с помощью скрипта.
````
#!/bin/bash
for i in {1..20};
        do dd if=/dev/urandom bs=1024 count=10 of=f$i;
done
~

````
после чего сделал снапшот

````
sudo lvcreate -L 5G -s -n snap_home /dev/mapper/VolGroup00-home

````
и удалли часть файлов

```
[vagrant@otuslinux ~]$ rm -rf f{1..10}
[vagrant@otuslinux ~]$ ls -l
total 136
-rwxrwxr-x. 1 vagrant vagrant    83 May 13 09:52 createf.sh
-rw-rw-r--. 1 vagrant vagrant 10240 May 13 09:52 f
-rw-rw-r--. 1 vagrant vagrant 10240 May 13 09:52 f11
-rw-rw-r--. 1 vagrant vagrant 10240 May 13 09:52 f12
-rw-rw-r--. 1 vagrant vagrant 10240 May 13 09:52 f13
-rw-rw-r--. 1 vagrant vagrant 10240 May 13 09:52 f14
-rw-rw-r--. 1 vagrant vagrant 10240 May 13 09:52 f15
-rw-rw-r--. 1 vagrant vagrant 10240 May 13 09:52 f16
-rw-rw-r--. 1 vagrant vagrant 10240 May 13 09:52 f17
-rw-rw-r--. 1 vagrant vagrant 10240 May 13 09:52 f18
-rw-rw-r--. 1 vagrant vagrant 10240 May 13 09:52 f19
-rw-rw-r--. 1 vagrant vagrant 10240 May 13 09:52 f20
```

для того что бы востоновить файлы, необходимо отмонтировать раздел. 

````
sudo umount /home
sudo lvconvert --merge /dev/VolGroup00/snap_home
sudo mount /dev/VolGroup00/home /home
````
Все, мы востоновились из снапшота. Задание __выполнено__.

6) прописать монтирование в fstab


7) попробовать с разными опциями и разными файловыми системами ( на выбор)
    - сгенерить файлы в /home/
    - снять снэпшот
    - удалить часть файлов
    - восстановится со снэпшота


  Доп. задание:

    -на нашей куче дисков попробовать поставить btrfs/zfs - с кешем, снэпшотами - разметить здесь каталог /opt. В настоящий момент не выполнено.
