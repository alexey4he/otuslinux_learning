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
  root centos -wi-ao---- 4.00g                                                    
  swap centos -wi-ao---- 4.00g                                                    
  var  centos -wi-ao---- 1.00g                                                    
[alexey4he@centoslvm ~]$ sudo lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   20G  0 disk 
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   11G  0 part 
  ├─centos-root 253:0    0    4G  0 lvm  /
  ├─centos-swap 253:1    0    4G  0 lvm  [SWAP]
  ├─centos-var  253:2    0    1G  0 lvm  /var
  └─centos-home 253:3    0    2G  0 lvm  /home
sr0              11:0    1 1024M  0 rom  
[alexey4he@centoslvm ~]$ sudo vgrename /dev/centos /dev/CentosForOtus
  Volume group "centos" successfully renamed to "CentosForOtus"
[alexey4he@centoslvm ~]$ sudo lvs
  LV   VG            Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  home CentosForOtus -wi-ao---- 2.00g                                                    
  root CentosForOtus -wi-ao---- 4.00g                                                    
  swap CentosForOtus -wi-ao---- 4.00g                                                    
  var  CentosForOtus -wi-ao---- 1.00g        
````
Т.к. имя **VG** изменилось. 
То и система не загрузится, если не поправим **grub.cfg** и **fstab**. 
Указываем правильные пути для томов и перезагружаемся.


___________________________________________________________________

~~Теперь займемся пунктом **1**. Необходимо после перезагрузки сразу попасть в систему, без пароля.
###### **1** Способ.
1. Сначала перезагружаем компьютер, когда появляется меню GRUB выбираем нашу версию ядра и нажимаем **e**.
2. Ишем строчку **linux16** в строчке ищем  **ro** и заменяем на **rw init=/sysroot/bin/sh**.
3. После этого нажимаем ctrl + x.
4. После загрузки мы находимся в однопользовательском режиме. С помощью команды chroot */sysroot/* мы можем примонтировать **/root**.~~
