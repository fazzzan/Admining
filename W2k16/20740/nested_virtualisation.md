Понадобилось потестировать создание виртуальных дисков VHD в VM. Чтобы заработала вложенная виртуализация, я пробую следующее:
```
Get-VM * | Format-Table Name, Version
```
![](pictures/Nested_VM_1.jpg)
Делаем upgrade 
```
Update-VMVersion <vmname>
```
или
![](pictures/Nested_VM_2.jpg)

Затем
```
Set-VMProcessor -VMName 20740B-LON-SVR1 -ExposeVirtualizationExtensions $true
Get-VMProcessor -VMName 20740B-LON-SVR1 | fl
```
![](pictures/Nested_VM_3.jpg)

Ну и внутри VM: systeminfo.exe

![](pictures/Nested_VM_4.jpg)

после этого удалось создать VHD файл
![](pictures/M2_l2_3.jpg)
