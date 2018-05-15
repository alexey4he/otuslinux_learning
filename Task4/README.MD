Домашнее задание №3:
========================
Тема: Работа с загрузчиком
-------------------------
**1.** Попасть в систему без пароля несколькими способами

**2.** Установить систему с LVM, после чего переименовать VG

**3.** Добавить модуль в initrd
______________________________________________________________________________________________________________________
Начал с **2** пункта. Установил Centos 7-1708. 
И переименовал VG, с **centos** в **CentosForOtus**.
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
попробывал сгенерировать конфиг файл **/boot/grub2/grub.cfg** и получил следующее:
````
[alexey4he@localhost ~]$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
/usr/sbin/grub2-probe: error: failed to get canonical path of ‘/dev/mapper/centos-root’.
````
Оказалось что не все так просто с **grub2-mkconfig**. 
Что бы сгенерировать конфиг пришлось, добавить **2** дополнительные строчки в  **/etc/default/grub** 
````
GrUB_DEVICE=/dev/CentosForOtus/root
GRUB_DEVICE_UUID=ed57b85f-befb-40a8-a658-f11839393057
````
и еще поправить сам **grub2-mkconfig**, звучит *ужасно*. Но это работает. 

**sudo vi /usr/sbin/grub2-mkconfig**
И в самом файле ищем строчку 
````
GRUB_DEVICE="`${grub_probe} --target=device /`"
````
И приводим ее к виду:
````
GRUB_DEVICE="`${grub_probe} --target=device /`" || true
````
Все, после этого **grub2-mkconfig -o /boot/grub2/grub.cfg** сгенерирует новый конфиг файл и можем перезагружаться.


___________________________________________________________________

Теперь займемся пунктом **1**. Необходимо после перезагрузки сразу попасть в систему, без пароля.
###### **1** Способ.
1. Сначала перезагружаем компьютер, когда появляется меню GRUB выбираем нашу версию ядра и нажимаем **e**.
2. Ишем строчку **linux16** в строчке ищем  **ro** и заменяем на **rw init=/sysroot/bin/sh**.
3. После этого нажимаем ctrl + x.
4. После загрузки мы находимся в однопользовательском режиме. 
    >>> что бы сбросить пароль root монтируем **root** раздел командой **chroot /sysroot**
    >>> сбрасываем пароль c помощью **passwd**
    >>> если есть **selinux** то необходимо создать файл **touch /.autorelabel** т.к. при выполнение команды passwd, создается новый файл /etc/shadow. А с помощью .autorelabel при следующей загрузке /etc/shadow будет пересоздан.  

###### **2** Способ.
В конфиге grub'a находим строку начинающуюся с **linux16** и в самый ее конец прописываем **rd.break** и грузимся как понимаю в **initramfs** оболочку.

###### **3** Способ.
Для загрузки в *аварийном* режиме, в конфиг grub'a в конец строки с **linux16** дописываем **systemd.unit=emergency.target**

###### **4** Способ.
Для загрузки в *rescue* режиме, можно выбрать этот режим через меню или дописать в конфиге в конце строки с **linux16** параметр **systemd.unit=rescue.target**
