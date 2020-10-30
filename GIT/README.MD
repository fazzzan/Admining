# КАК  ЖЕ МЕНЯ БЕСИТ ЭТОТ GIT

Итак, в двух словах для WIN:

1. Надо установить клиент git: обязательно потребуется консольный клиент, доступный по ссылке <http://git-scm.com/downloads>
2. Надо иметь регистрацию на <https://github.com/>
3. Открываем консольный клиент.
4. Переходим в каталог, где у нас будут лежать все репозитарии, в моем случае E:\Study\GIT\Admining

```
 cd /e/Study/GIT/Admining/
```

5. Делаем странное телодвижение, которое говорит что в каталоге Admining будет лежать репозиторий Admining... Тут я жестко обманулся, надо было делать 
cd /e/Study/GIT/

```
$ git init
Initialized empty Git repository in E:/Study/GIT/Admining/.git/
```

6. Копируем в каталог все г..., что налабали в https

```
 $ git clone https://github.com/fazzzan/Admining
Cloning into 'Admining'...
remote: Enumerating objects: 141, done.
remote: Counting objects: 100% (141/141), done.
remote: Compressing objects: 100% (121/121), done.
remote: Total 141 (delta 24), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (141/141), 386.69 KiB | 801.00 KiB/s, done.
Resolving deltas: 100% (24/24), done.
```
7. Задаем учетную запись пользователя GIT
```
git config --global user.email "fzakharov@mail.ru"
git config --global user.name "fazzzan"
```
8. Если добавляем каталог в корень репозитория, то проверяем статус, добавляем каталог в трекинг и делаем commit:

```
$ git status
On branch master
Your branch is up to date with 'origin/master'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        GIT/

nothing added to commit but untracked files present (use "git add" to track)

Fedor@DESKTOP-1C3288U MINGW64 /e/Study/GIT/Admining/Admining (master)
$ git commit -a
On branch master
Your branch is up to date with 'origin/master'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        GIT/

nothing added to commit but untracked files present (use "git add" to track)

Fedor@DESKTOP-1C3288U MINGW64 /e/Study/GIT/Admining/Admining (master)
$ git add GIT/

Fedor@DESKTOP-1C3288U MINGW64 /e/Study/GIT/Admining/Admining (master)
$ git commit -a
[master b20d600]        new file:   GIT/README.MD
 1 file changed, 32 insertions(+)
 create mode 100644 GIT/README.MD
```
# ВАЖНО
при commit у нас возникает окно, которое отображает что именно будет закоммичено. Удаляем # на тех файлах, которые должны улететь на GIT
и нажимаем
":wq"

9. Затем, ПУШИМ все что ЗАКОММИТИЛИ на GIT:
```
$  git push
Enumerating objects: 13, done.
Counting objects: 100% (13/13), done.
Delta compression using up to 12 threads
Compressing objects: 100% (9/9), done.
Writing objects: 100% (12/12), 2.25 KiB | 1.12 MiB/s, done.
Total 12 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), done.
To https://github.com/fazzzan/Admining
   a0809ad..ef9d00c  master -> master

```

10. Если что-то добавляли через WEB-морду, то это что-то закачиваем в локалный репозиторий:

```
Fedor@DESKTOP-1C3288U MINGW64 /e/Study/GIT/DarkMycal (master)
$ git pull
Already up to date.
```

11. из репозитория в репозиторий прыгаем командой 

```
cd ..
cd <XYZ>
git init
git status
git add . 
git commit
git push
```
