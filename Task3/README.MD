Домашнее задание №3:
========================
Тема: Работа с LVM
-------------------------

### Задача:

_на имеющемся образе /dev/mapper/VolGroup00-LogVol00 38G 738M 37G 2% /_

#### 1)Уменьшить том под / до 8G
#### 2)выделить том под /home
#### 3)выделить том под /var
#### 4)/var - сделать в mirror
#### 5)/home - сделать том для снэпшотов
#### 6)прописать монтирование в fstab
#### 7)попробовать с разными опциями и разными файловыми системами ( на выбор)
#####     - сгенерить файлы в /home/
#####     - снять снэпшот
#####     - удалить часть файлов
#####     - восстановится со снэпшота
#####     - залоггировать работу можно с помощью утилиты screen


## Решение:
_________________


Я решил попробывать изменить __/__ без LiveCd. Для начала мне надо из свободных дисков собрать Volume Group и перенести туда __/__. 

````bash
sudo pvcreate /dev/sd{b,c,d}
sudo vgcreate vg0 /dev/sdc /dev/sdb /dev/sdd
sudo lvcreate -l 100%FREE -n root_temp vg0
sudo vgscan && sudo vgchange -ay
sudo mkfs.xfs /dev/vg0/root_temp
sudo mount /dev/mapper/vg0-root_temp /mnt/
sudo yum install xfsdump -y
sudo xfsdump -f /tmp/rootdump /dev/mapper/VolGroup00-LogVol00
sudo xfsrestore -f /tmp/rootdump /mnt/
````
Раздел создан, теперь с него необходимо загрузиться. 
Необходимо в __/boot/grub2/grub.cfg__ изменить путь до  __root__ раздела. 
Ищем __*/dev/mapper/VolGroup00-LogVol00*__ и заменяем на __*/dev/mapper/vg0-root_temp*__.
А __*rd.lvm.lv=VolGroup00/LogVol00*__ на __*rd.lvm.lv=vg0/root_temp*__.
После чего перезагружаемся.


После этого, подправил _/boot/grub2/grub.cfg_.
Для того что бы грузиться по умолчанию с __/dev/mapper/vg0-roottemp__

_______________

...
linux16 /vmlinuz-3.10.0-693.21.1.el7.x86_64 __root=/dev/mapper/vg0-roottemp__ ro
no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0
crashkernel=auto __rd.lvm.lv=vg0/roottemp__ rd.lvm.lv=VolGroup00/LogVol01 rhgb quiet
...

Так же решил поправить __fstab__, на временом разделе. Без него система тоже грузится, но думаю что это будет не лишним.
т.к. _временный **root**_ пока примонтирован в **/mnt/**, то и **fstab** надо править там. 

````
sudo vi /mnt/etc/fstab
````
_/dev/mapper/vg0-root_temp       /                       xfs     defaults        0 0_ монтируем **временный root**

~~#/dev/mapper/VolGroup00-LogVol00 /                       xfs     defaults        0 0_~~ удаляем запись о старом. 
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

#### 2) выделить том под /home
````
sudo lvcreate -L 8G -n home VolGroup00
sudo mkdir /tmp/home
sudo cp -ra /home/* /tmp/home/
sudo mkfs.ext4 /dev/mapper/VolGroup00-home
sudo mount /dev/mapper/VolGroup00-home /home
sudp cp -ra /tmp/home/* /home/
````
Задание __выполнено__.

#### 3 + 4)  выделить том под /var + /var - сделать в mirror
````
sudo vgremove vg0


````



#### 6) прописать монтирование в fstab


#### 5+7) /home - сделать том для снэпшотов попробовать с разными опциями и разными файловыми системами ( на выбор)
    - сгенерить файлы в /home/
    - снять снэпшот
    - удалить часть файлов
    - восстановится со снэпшота
Сгенировал, несколько файлов в __/home/vagrant__ с помощью скрипта.
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
