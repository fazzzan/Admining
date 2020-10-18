# Обновления Win - сколько себя помню было темным лесом.

Во второй вторник каждого месяца Microsoft выпускает исправления в системе безопасности своих программных продуктов, сопровождая их бюллетенями безопасности. Один бюллетень может содержать информацию о нескольких уязвимостях (CVE), которые закрывает описываемое исправление системы безопасности.

### Попалась статья и программа BatchPatch.exe
https://mywebpc.ru/windows/ustanovit-obnovleniya-windows-bez-interneta/

Команда проверки установленных обновлений
wmic qfe list
```
C:\WINDOWS\system32>wmic qfe list
Caption                                     CSName           Description      FixComments  HotFixID   InstallDate  InstalledBy          InstalledOn  Name  ServicePackInEffect  Status
http://support.microsoft.com/?kbid=4570723  DESKTOP-7A30CGP  Update                        KB4570723               NT AUTHORITY\SYSTEM  8/22/2020
http://support.microsoft.com/?kbid=4497165  DESKTOP-7A30CGP  Update                        KB4497165               NT AUTHORITY\SYSTEM  8/22/2020
http://support.microsoft.com/?kbid=4515530  DESKTOP-7A30CGP  Security Update               KB4515530               NT AUTHORITY\SYSTEM  10/1/2019
http://support.microsoft.com/?kbid=4516115  DESKTOP-7A30CGP  Security Update               KB4516115               NT AUTHORITY\SYSTEM  10/12/2019
http://support.microsoft.com/?kbid=4517245  DESKTOP-7A30CGP  Update                        KB4517245               NT AUTHORITY\SYSTEM  8/22/2020
http://support.microsoft.com/?kbid=4524569  DESKTOP-7A30CGP  Security Update               KB4524569               NT AUTHORITY\SYSTEM  12/7/2019
http://support.microsoft.com/?kbid=4561600  DESKTOP-7A30CGP  Security Update               KB4561600               NT AUTHORITY\SYSTEM  8/22/2020
http://support.microsoft.com/?kbid=4569073  DESKTOP-7A30CGP  Security Update               KB4569073               NT AUTHORITY\SYSTEM  8/22/2020
https://support.microsoft.com/help/4566116  DESKTOP-7A30CGP  Update                        KB4566116               NT AUTHORITY\SYSTEM  8/22/2020

```

### Еще статья про обновления Win 10
http://www.outsidethebox.ms/18347/

Накопительные обновления. 
В Windows 10, в отличие от предыдущих систем, основная масса обновлений (в том числе, исправлений системы безопасности) доставляется в накопительных пакетах (cumulative updates). Они выходят примерно раз в месяц и заменяют ранее выпущенные обновления, если необходимо (в примере — это KB3154132). Именно накопительные обновления значительно упрощают задачу поддержания в актуальном состоянии ПК, с выключенным WU.

Прочие обновления ОС. 
Их немного, и в моем случае предлагается только одно – KB3140741, обновляющее сервисный стек Windows. Без таких обновлений можно жить [на даче], иначе их бы включали в первую категорию. Впрочем, обновление стека может стать обязательным для установки новой версии Windows 10.

Обновления защитника Windows, MSRT и Flash Player. 
С первыми двумя все понятно(антивирус и MS zlovred Remove Tool), но не вполне очевидно, что мешает включать обновления Flash Player в накопительные пакеты. Возможно, Flash приходится обновлять чаще раза в месяц.

Шаг 1 — Определите версию и разрядность ОС
Параметры → Система → О программе, или Winver
![](http://www.outsidethebox.ms/blog/wp-content/uploads/blog-images/about-windows.png)

Шаг 2 — Скачайте обновления ОС, Flash Player и MSRT
Перейдите в каталог обновлений Microsoft, например для моего домашнего ПК
```
https://www.catalog.update.microsoft.com/Search.aspx?q=windows+10+1909+x64
```
в поиск надо ввести название ОС вместе с версией и разрядностью, например, Windows 10 1809 x64 или Windows 10 1909 x64. Это даст вам обновления Windows (накопительные, сервисный стек, .NET) и Flash Player. 

Чтобы найти последнюю версию MSRT, введите в поиск removal tool и отсортируйте по дате, отобразив последние результаты сверху. При просмотре можно проверить у последнего - какие из ранее выпущенных MSRT она заменяет
```
Общий список: https://www.catalog.update.microsoft.com/Search.aspx?q=removal%20tool
для 8.1: https://www.catalog.update.microsoft.com/Search.aspx?q=Windows+8.1+removal+tool
```

Шаг 3 — Скачайте обновление сигнатур защитника Windows
Чтобы не рыться в каталоге, перейдите на сайт Malware Protection Center и скачайте файл для оффлайн-установки (Windows Defender in Windows 10 and Windows 8.1). 
```
https://www.microsoft.com/en-us/wdsi/defenderupdates#manual

Note: Starting on Monday October 21, 2019, the Security intelligence update packages will be SHA2 signed.
Please make sure you have the necessary update installed to support SHA2 signing, see 2019 SHA-2 Code Signing Support requirement for Windows and WSUS.
Microsoft Defender Antivirus for Windows 10 and Windows 8.1 	32-bit | 64-bit | ARM
Microsoft Security Essentials 	32-bit | 64-bit
Windows Defender in Windows 7 and Windows Vista 	32-bit | 64-bit
Microsoft Diagnostics and Recovery Toolset (DaRT) 	32-bit | 64-bit
System Center 2012 Configuration Manager 	32-bit | 64-bit
System Center 2012 Endpoint Protection 	32-bit | 64-bit
Windows Intune 	32-bit | 64-bit
```
Пример: поиска последнего накопительное обновление

- Шаг 1. Перейдите на https://support.microsoft.com/en-us/hub/4338813/windows-help?os=windows-8.1 и определите номер статьи KB по номеру вашей версии/сборки (Winver). Рекомендуется сверяться с английским журналом, т.к. eго русский вариант имеет свойство сильно отставать. Если нельзя посмотреть версию ОС (ПК остался на даче), придется скачать обновления для обеих версий и определиться позже (в любом случае ненужное не получится установить). Например в Winver у меня
```
Версия 1909 (сборка ОС 18363.1049)
```
Значит тут https://support.microsoft.com/en-us/help/4529964/windows-10-update-history ищем (ctrl+F):
- Сначала слева вверху 1909
- Затем перейдя по ссылке, ищем 18363.1049
Далее внимательно читаем:
```
How to get this update
Before installing this update
Microsoft strongly recommends you install the latest servicing stack update (SSU) for your operating system before installing the latest cumulative update (LCU). SSUs improve the reliability of the update process to mitigate potential issues while installing the LCU. For general information about SSUs, see Servicing stack updates and Servicing Stack Updates (SSU): Frequently Asked Questions.

If you are using Windows Update, the latest SSU (KB4569073) will be offered to you automatically. To get the standalone package for the latest SSU, search for it in the Microsoft Update Catalog.
```
Из комадны "wmic qfe list" видно, что у меня установлен latest SSU
```
http://support.microsoft.com/?kbid=4569073  DESKTOP-7A30CGP  Security Update               KB4569073               NT AUTHORITY\SYSTEM  8/22/2020
```
И в принципе нам ничто не мешает скачать обновления
https://www.catalog.update.microsoft.com/Search.aspx?q=KB4566116
и тут снова осознанно выбираем 	"2020-08 Предварительный просмотр накопительного обновления для Windows 10 Version 1909 для основанных на x64 системах (KB4566116)"
Для 8.1 - ситуация похожа: https://support.microsoft.com/en-us/help/4009470/windows-8-1-windows-server-2012-r2-update-history


Шаг 2. Откройте каталог обновлений и введите в поиск номер статьи KB.

Как скачать обновления Windows 10
Обновление Flash Player и MSRT
В том же каталоге введите в поиск flash player и removal tool, а потом отсортируйте обновления по дате, щелкнув заголовок столбца Последнее обновление. Нужное будет вверху списка.

Более старые ОС я не рассматриваю сознательно. Если ПК до сих пор с Windows 8.1, имеет смысл обновиться до Windows 10, а для Windows 7 уже после выхода этой статьи появился эквивалент SP2. См. также WSUS Offline Update и доставляйте другие интересные способы в комментарии!


### Еще статья про обновления Win 10, на основании которой я установил обновления на домашнюю Win 10
http://www.outsidethebox.ms/16603/#_Toc391929377

Скачал отсюда архив PoSH: https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc
Сохраните архив PSWindowsUpdate.zip на USB-диск и (это важно!) щелкните на нем ПКМ – Свойства – Разблокировать файл.
Cохраните на USB-диске файл wu.cmd с одной командой:
```
PowerShell -ExecutionPolicy RemoteSigned -Command Import-Module PSWindowsUpdate; Get-WUInstall -AcceptAll -IgnoreReboot
```
В режиме аудита щелкните ПКМ на архиве – Распаковать все и выберите папку
```    
C:\Windows\System32\WindowsPowerShell\v1.0\Modules
```    
Щелкните ПКМ на wu.cmd и выберите Запуск от имени администратора. Это все! Доступные обновления загрузятся и установятся автоматически.

Если вы хотите просто посмотреть список доступных обновлений, замените последний блок команды (после точки с запятой) на:
```
PowerShell -ExecutionPolicy RemoteSigned -Command Import-Module PSWindowsUpdate; Get-WUInstall -ListOnly -IgnoreReboot
```
По завершении обновления надо удалить модуль, ранее скопированный в папку Windows.
