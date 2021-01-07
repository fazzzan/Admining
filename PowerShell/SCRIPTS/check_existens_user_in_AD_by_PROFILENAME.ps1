Import-Module ActiveDirectory

#$Path = "D:\Уволенные"
$Path = "\\s-dat-03\d$\Personal"
$LogPath = "c:\Temp"
foreach ($pathin in Get-ChildItem -Path $Path)
{    
    $ExistingADUser = Get-ADUser -Filter "SamAccountName -eq '$pathin'"
    if($null -eq $ExistingADUser){
        write-host "'$pathin' SamAccountName '$pathin' does not exist in active directory" 
    }
}
    
# проверка овнера каталога
# Get-ChildItem $Path -force | Select Name,Directory,@{Name="Owner";Expression={(Get-ACL $_.Fullname).Owner}},CreationTime,LastAccessTime | Export-Csv $LogPath\FileFolderOwner.txt -NoTypeInformation
