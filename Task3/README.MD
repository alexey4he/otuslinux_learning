Домашнее задание №3:
========================
Работа с LVM
-------------------------

**_на имеющемся образе /dev/mapper/VolGroup00-LogVol00 38G 738M 37G 2% /_**


1) уменьшить том под / до 8G:
___

  Интересно было сделать именно без LiveCd.
  ###


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

###

...
linux16 /vmlinuz-3.10.0-693.21.1.el7.x86_64 __root=/dev/mapper/vg0-roottemp__ ro
no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0
crashkernel=auto __rd.lvm.lv=vg0/roottemp__ rd.lvm.lv=VolGroup00/LogVol01 rhgb quiet
...

###

2) выделить том под /home
3) выделить том под /var
4) /var - сделать в mirror
5) /home - сделать том для снэпшотов
6) прописать монтирование в fstab
7) попробовать с разными опциями и разными файловыми системами ( на выбор)
    - сгенерить файлы в /home/
    - снять снэпшот
    - удалить часть файлов
    - восстановится со снэпшота


  Доп. задание:

    -на нашей куче дисков попробовать поставить btrfs/zfs - с кешем, снэпшотами - разметить здесь каталог /opt. В настоящий момент не выполнено.
