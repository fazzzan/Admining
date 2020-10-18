# Module2/Lesson2 - Managing volumes in Windows Server
```
diskpart
List disk 
Select disk 3 
Online disk - если он offline
Attributes disk clear readonly - Если возникает ошибка Disk Readonly
Convert dynamic 
Create volume simple size=500 disk=3 
list volume
assign letter=G 
format FS=NTFS Label="Mirror"
```
![](pictures/M2_l2_1.jpg)

Добавление Mirror
```
Select disk 4 
Online disk - если он offline
Attributes disk clear readonly - Если возникает ошибка Disk Readonly или WriteProtected
Convert dynamic 
list volume
Select volume 5
add disk 4 - Результатом будет DiskPart succeeded in adding a mirror to the volume.
```
Создание RAID из 3 onlyne Dynamic дисков:
```
create volume raid size=1000 disk=1,2,3
list volume
select volume <X> - выбираем вновь созданный том
assign letter=G 
format FS=NTFS Label="Mirror"

```
![](pictures/M2_l2_2.jpg)

Удаление тома
```
list volume
select volume <X>
delete volume - 
```

Работа с VHD дисками
```
• New-VHD. New-VHD -Path c:\sales.vhd -Dynamic -SizeBytes 10Gb 
• Mount-VHD. Use this command to mount the VHD to create volumes and format files systems. 
• Initialize-disk. Use this command to initialize the disk in preparation for creating volumes. 
• Get-vhd. Use this command to retrieve information about a named .vhd file. 
• Set-vhd. Use this cmdlet to configure the .vhd file properties. For example, the following cmdlet 
changes the physical sector size of the Sales.vhdx file. 
Set-VHD –Path c:\Sales.vhdx –PhysicalSectorSizeBytes 4096 
• Convert-vhd. You can use the Convert-vhd cmdlet to change from a VHD to a VHDX file format.

New-VHD -Path G:\sales1.vhd -Dynamic -SizeBytes 10Gb | Mount-VHD -Passthru |Initialize-Disk -
Passthru |New-Partition -AssignDriveLetter -UseMaximumSize |Format-Volume -FileSystem NTFS -
Confirm:$false -Force 
```
