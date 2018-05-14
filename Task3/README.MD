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


Я решил попробывать изменить __/__ без LiveCd. Поднимем LVM на одном из дисков для  __/__ раздела.. 

````bash
sudo pvcreate /dev/sdc
sudo vgcreate vg0 /dev/sdc
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

Так же решил поправить __fstab__, на временом разделе. Без него система тоже грузится, но думаю что это не будет лишним.
т.к. _временный **root**_ пока примонтирован в **/mnt/**, то и **fstab** надо править там. 


````
sudo vi /mnt/etc/fstab
````
_/dev/mapper/vg0-root_temp       /                       xfs     defaults        0 0_ монтируем **временный /root**

~~#/dev/mapper/VolGroup00-LogVol00 /                       xfs     defaults        0 0_~~ удаляем запись о старом. 


После чего **перезагружаемся.**

После перезагрузки, подключаемся к системе и проверяем куда примонтирован **/root** раздел.

''''
[vagrant@otuslinux ~]$ sudo lsblk
NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                       8:0    0   40G  0 disk
├─sda1                    8:1    0    1M  0 part
├─sda2                    8:2    0    1G  0 part /boot
└─sda3                    8:3    0   39G  0 part
  ├─VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]
  └─VolGroup00-LogVol00 253:2    0 37.5G  0 lvm
sdb                       8:16   0  250M  0 disk
sdc                       8:32   0  2.5G  0 disk
└─vg0-root_temp         253:0    0  2.4G  0 lvm  /
sdd                       8:48   0  1.5G  0 disk

''''

**/root**, у нас на **vg-root_temp**. Отлично!
Теперь можем удалить старый LG на котором находился *старый **/root***

''''
sudo lvremove /dev/VolGroup00/LogVol00
''''
Раздел удалили. Теперь можно сразу создать раздел для **/root** и для **/home** на **sda3**.

''''
sudo lvcreate -L 8G -n LogVol_root VolGroup00
sudo lvcreate -L 8G -n LogVol_home VolGroup00 

sudo mkfs.xfs /dev/VolGroup00/LogVol_root
sudo mkfs.ext4 /dev/VolGroup00/LogVol_home
''''
Создали, отфомотировали.
Пора перенести **/root**, на новый раздел:

''''
sudo xfsdump -f /tmp/rootdump /dev/mapper/vg0-root_temp
sudo mount /dev/mapper/VolGroup00-LogVol_root /mnt/
sudo xfsrestore -f /tmp/rootdump /mnt/
''''
**/root** готов. 

Прежде чем грузиться с нового раздела, я решил сразу подготовить разделы для **/home** и  **/var**.
Начнем с **/home**:

''''
sudo mount /dev/mapper/VolGroup00-LogVol_home /mnt/
sudo cp -ra /home/* /mnt/
''''
Данные перенесли, раздел готов к монтированию.

Осталось разобраться с **/var** в **mirror**. Мы специально оставили 2 диска, не тронутыми. Приступаем к ним.
''''
sudo pvcreate /dev/sd{b,d}
sudo vgcreate vg1 /dev/sdb /dev/sdd
sudo lvcreate -L 240M -m1 -n LogVol_var vg1
sudo mkfs.ext4 /dev/mapper/vg1-LogVol_var
sudo mount /dev/mapper/vg1-LogVol_var /mnt/
sudo cp -ra /var/* /mnt/
''''

Все готово, осталось указать в **fstab** на новом томе куда, что монтировать:

''''
sudo mount /dev/mapper/VolGroup00-LogVol_root /mnt/
sudo vi /mnt/etc/fstab
''''

_/dev/mapper/VolGroup00-LogVol_root       /                       xfs     defaults        0 0_ монтируем **/root** размером 8Gb
_/dev/mapper/VolGroup00-LogVol_home       /home                     ex4     defaults        0 0_ монтируем **/home** 
_/dev/mapper/vg1-LogVol_var      /var                      ext4     defaults        0 0_ монтируем **/var** в **mirror**
~~/dev/mapper/vg0-root_temp       /                       xfs     defaults        0 0_ монтируем~~**временный /root** нам больше не нужен


Оставлось исправить **grub.cfg**
 
Правим __*/dev/mapper/vg0-root_temp*__ на __*/dev/mapper/VolGroup00-LogVol_root*__.
А __*rd.lvm.lv=vg0/root_temp*__ на __*VolGroup00/LogVol_root*__.

и перезагрузиться.

_______________

После перезагрузки, гляним как примонтированы тома.
''''
sudo lsblk
NAME                       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                          8:0    0   40G  0 disk
├─sda1                       8:1    0    1M  0 part
├─sda2                       8:2    0    1G  0 part /boot
└─sda3                       8:3    0   39G  0 part
  ├─VolGroup00-LogVol_root 253:0    0    8G  0 lvm  /
  ├─VolGroup00-LogVol01    253:1    0  1.5G  0 lvm  [SWAP]
  └─VolGroup00-LogVol_home 253:3    0    8G  0 lvm  /home
sdb                          8:16   0  250M  0 disk
├─vg1-LogVol_var_rmeta_0   253:4    0    4M  0 lvm
│ └─vg1-LogVol_var         253:8    0  240M  0 lvm  /var
└─vg1-LogVol_var_rimage_0  253:5    0  240M  0 lvm
  └─vg1-LogVol_var         253:8    0  240M  0 lvm  /var
sdc                          8:32   0  2.5G  0 disk
└─vg0-root_temp            253:2    0  2.4G  0 lvm
sdd                          8:48   0  1.5G  0 disk
├─vg1-LogVol_var_rmeta_1   253:6    0    4M  0 lvm
│ └─vg1-LogVol_var         253:8    0  240M  0 lvm  /var
└─vg1-LogVol_var_rimage_1  253:7    0  240M  0 lvm
  └─vg1-LogVol_var         253:8    0  240M  0 lvm  /var

''''
Отлично! Все правильно. 
Осталось создать несколько файлов в **home** и попробывать создать **snapshot**.
С помощью скрипта **fgen.sh**:
````
#!/bin/bash
for i in {1..20};
        do dd if=/dev/urandom bs=1024 count=10 of=f$i;
done
````
Создадим 20 файлов, а потом сделаем снапшот **/home**:
````
chmod +x ./fgen.sh
./fgen.sh
 ls
f1   f11  f13  f15  f17  f19  f20  f4  f6  f8  fgen.sh
f10  f12  f14  f16  f18  f2   f3   f5  f7  f9  screenlog.0
sudo lvcreate -L 5G -s -n snap_home /dev/mapper/VolGroup00-LogVol_home
````
А теперь удалим 10 файлов, и попробуем откатиться к снапшоту.
````
sudo rm f{1..10}
ls
f11  f12  f13  f14  f15  f16  f17  f18  f19  f20  fgen.sh  screenlog.0
sudo umount /home
sudo lvconvert --merge /dev/VolGroup00/snap_home
/dev/mapper/VolGroup00-LogVol_home 
ls
f1  f10  f11  f12  f13  f14  f15  f16  f17  f18  f19  f2  f20  f3  f4  f5  f6  f7  f8  f9  fgen.sh  screenlog.0
````
Файлы востоновили. 
На этом основное ДЗ, закончено. Доп, задание попробую выполнить позже.

