# Module2/Lesson1 - Managing disk in windows server
### Powershell для работы с дисками
```
fsutil fsinfo volumeinfo f:
fsutil fsinfo sectorinfo f:
Format-Volume -Driveletter F -FileSystem NTFS
Format-Volume -Driveletter F -FileSystem ReFS
```
