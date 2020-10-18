Понадобилось потестировать создание виртуальных дисков VHD в VM. Чтобы заработала вложенная виртуализация, я пробую следующее:
```
Get-VM * | Format-Table Name, Version
```
![](Lessons/pictures/Nested_VM_1.jpg)
Делаем upgrade 
```
Update-VMVersion <vmname>
```
или
![](Lessons/pictures/Nested_VM_2.jpg)

Затем
```
Set-VMProcessor -VMName 20740B-LON-SVR1 -ExposeVirtualizationExtensions $true
Get-VMProcessor -VMName 20740B-LON-SVR1 | fl
```
![](Lessons/pictures/Nested_VM_3.jpg)

Ну и внутри VM: systeminfo.exe

![](Lessons/pictures/Nested_VM_4.jpg)

после этого удалось создать VHD файл
![](Lessons/pictures/M2_l2_3.jpg)
