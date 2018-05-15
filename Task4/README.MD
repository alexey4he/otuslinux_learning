Домашнее задание №3:
========================
Тема: Работа с загрузчиком
-------------------------
**1.** Попасть в систему без пароля несколькими способами

**2.** Установить систему с LVM, после чего переименовать VG

**3.** Добавить модуль в initrd
______________________________________________________________________________________________________________________
Начал с **2** пункта. Установил Centos 7-1708. 
И переименовал VG, с **cento** в **CentosForOtus**.
````
[alexey4he@centoslvm ~]cat /etc/system-release
CentOS Linux release 7.4.1708 (Core)
[alexey4he@centoslvm ~]sudo lvs
  LV   VG     Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  home centos -wi-ao---- 2.00g                                                    
  root centos -wi-ao---- 3.00g                                                    
  swap centos -wi-ao---- 2.00g                                                    
  var  centos -wi-ao---- 2.00g                                                    
[alexey4he@centoslvm ~]$ sudo lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   20G  0 disk 
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0    9G  0 part 
  ├─centos-root 253:0    0    3G  0 lvm  /
  ├─centos-swap 253:1    0    2G  0 lvm  [SWAP]
  ├─centos-var  253:2    0    2G  0 lvm  /var
  └─centos-home 253:3    0    2G  0 lvm  /home
sr0              11:0    1 1024M  0 rom  
[alexey4he@centoslvm ~]$ sudo vgrename /dev/centos /dev/CentosForOtus
  Volume group "centos" successfully renamed to "CentosForOtus"
[alexey4he@centoslvm ~]$ sudo lvs
  LV   VG            Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  home CentosForOtus -wi-ao---- 2.00g                                                    
  root CentosForOtus -wi-ao---- 3.00g                                                    
  swap CentosForOtus -wi-ao---- 2.00g                                                    
  var  CentosForOtus -wi-ao---- 2.00g        
````
Т.к. имя **VG** изменилось, соотвественно система не стартанет т.к. надо изменить конфиг **grub.cfg** и **fstab**.
Правим **/etc/fstab**
````
/dev/mapper/CentosForOtus-root /                       ext4    defaults        1 1
UUID=ddb636bb-c4b4-462a-b564-d1332cd0b760 /boot                   ext4    defaults        1 2
/dev/mapper/CentosForOtus-home /home                   ext4    defaults        1 2
/dev/mapper/CentosForOtus-var  /var                    ext4    defaults        1 2
/dev/mapper/CentosForOtus-swap swap                    swap    defaults        0 0
````
В этот раз не будем на прямую править конфиг файл **/boot/grub2/grub.cfg**, а попробуем его сгенирировать с помощью **grub2-mkconfig**.
Для этого приведем строчку в **/etc/default/grub**к такому виду: 
````
GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=CentosForOtus/root rd.lvm.lv=CentosForOtus/swap"
````


___________________________________________________________________

~~Теперь займемся пунктом **1**. Необходимо после перезагрузки сразу попасть в систему, без пароля.
###### **1** Способ.
1. Сначала перезагружаем компьютер, когда появляется меню GRUB выбираем нашу версию ядра и нажимаем **e**.
2. Ишем строчку **linux16** в строчке ищем  **ro** и заменяем на **rw init=/sysroot/bin/sh**.
3. После этого нажимаем ctrl + x.
4. После загрузки мы находимся в однопользовательском режиме. С помощью команды chroot */sysroot/* мы можем примонтировать **/root**.~~
