
# Установка git
## Подключение дополнительного IF с выходом наружу
## Запуск YAML для установки
```
- name: Deploy git
  hosts: ansible1
  gather_facts: false
  tasks:
  - block:
    - name: install git
      ansible.builtin.package:
        name: git
        state: present
  - block:
    - name: install gitweb
      ansible.builtin.package:
        name: gitweb
        state: present        
- name: get installed git soft
  hosts: ansible1
  gather_facts: false
  tasks:
  - name: get installed soft
    shell: dnf list installed | grep git
    register: git_status

  - name: Debug registered var
    debug: var=git_status
```

[Настройка0](https://fkn.ktu10.com/?q=node/5645)
[Настройка1](https://www.server-world.info/en/note?os=CentOS_8&p=git&f=5)
[Настройка разных типов доступа](https://sethrobertson.github.io/HowToPutGitOnTheWeb/GitOnTheWeb.html)

Регистрируем пользователя и группу в ОС
```
sudo adduser gitrepo   
sudo passwd gitrepo
usermod -a -G wheel gitrepo
Добавляем пользователя APACHE в группу gitrepo
usermod -a -G gitrepo apache
```

Устанавливаем GIT
```
su gitrepo
sudo dnf install git-all
Проверяем версии ПО
git --version
httpd -v
```

Настраиваем APACHE
```

sudo su
cp /etc/httpd/conf.d/git.conf /etc/httpd/conf.d/git.conf.bak
vi /etc/httpd/conf.d/git.conf 

<VirtualHost *:80>
SetEnv GIT_PROJECT_ROOT /var/lib
SetEnv GIT_HTTP_EXPORT_ALL
ScriptAlias /gitweb.cgi /var/www/git/gitweb.cgi
    ScriptAliasMatch \
        "(?x)^/(.*git/(HEAD | \
                        info/refs | \
                        objects/(info/[^/]+ | \
                                 [0-9a-f]{2}/[0-9a-f]{38} | \
                                 pack/pack-[0-9a-f]{40}\.(pack|idx)) | \
                        git-(upload|receive)-pack))$" \
        /usr/libexec/git-core/git-http-backend/$1

  <Directory "/usr/libexec/git-core">
    Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
    AddHandler cgi-script .cgi .pl
    AllowOverride None
    Require all granted
  </Directory>

  Alias /git /var/lib/git

<Location /git>
    Options +ExecCGI
    AuthName "Git for HTTP"
    AuthType Basic
    AuthUserFile /etc/httpd/conf/.htpasswd
    Require valid-user
    DirectoryIndex /gitweb.cgi
</Location> 
</VirtualHost>
```

Регистрируем пользователя репозитория
```
git config --global user.name "gitrepo" 
git config --global user.email gitrepo@test.local
```

Назначаем права на каталог git
```
cd /var/lib/git
sudo chown -R root.gitrepo /var/lib/git
sudo chmod 775 -R /var/lib/git
Задаем пароль пользователя для доступа по HTTP (-с - создает файл)
htpasswd -c /etc/httpd/conf/.htpasswd gitrepo
htpasswd /etc/httpd/conf/.htpasswd fedor

Тестирование
Через http
 [root@ansible1 git]# su -s /bin/bash apache
 mkdir /var/lib/git/project01.git/objects/test
```

[Настраиваем каталог "голого" репозиторитория](http://www-cs-students.stanford.edu/~blynn/gitmagic/intl/ru/ch04.html)
```
cd /var/lib/git
ls -lah
mkdir project.git 
cd project.git 
##git init --bare 
##git --bare init --shared=all
git init --bare --shared=group
cd 
### git init
mv hooks/post-update.sample hooks/post-update   
```

Отключаем SELINUX - будем с ним разбираться позже
```
sudo vi /etc/selinux/config
SELINUX=permissiv   

sudo setenforce 0
sudo reboot

В планах разобраться с SELinux
##   51  setsebool -P domain_can_mmap_files on 
##   52  vi smart-git.te 
##   53  ls -lah
##   54  checkmodule -m -M -o smart-git.mod smart-git.te
##   55  semodule_package --outfile smart-git.pp --module smart-git.mod 
##   56  semodule -i smart-git.pp 

```

После этих мучений можно создавать свой проект и пушить его в репозиторий по http (https://www.server-world.info/en/note?os=CentOS_8&p=git&f=13)
```
A) локально 
cd /var/lib/git
sudo mkdir work
mkdir project
cd project/
git init
echo 'test'>READMI.MD
git add .
git commit -m "commit all" -a

git remote add origin http://gitrepo@192.168.48.23/git/project.git
git branch -M master
git push -u origin master

B) через VSCODE
git clone http://gitrepo@192.168.48.23/git/project.git

```

Проверка
```
git log

cat /var/log/httpd/error_log
### git config receive.denyCurrentBranch ignore   

```

```
cp -R /var/www/git/ /var/www/git.bak

cd /var/www/git

sudo vi /etc/gitweb.conf
our $projectroot = "/var/www/git";

sudo vi /etc/httpd/conf.d/git.conf

Alias /git /var/www/git
<Directory /var/www/git>
  Options +FollowSymLinks +ExecCGI
  AddHandler cgi-script .cgi
  DirectoryIndex gitweb.cgi
</Directory>

systemctl restart httpd

Проверка от кого запущен httpd/apace
`ps -ef | grep [a]pache`

chgrp -R apache /var/www/git
???  chown -R apache:apache /var/www/git ???
chmod -R g+w /var/www/git

echo "Alias /g /var/www/git" >> /etc/httpd/conf.d/git.conf

[root@ansible1 administrator]# git config --list --show-origin
[root@ansible1 administrator]# git config --global user.name "root"    
[root@ansible1 administrator]# git config --global user.email "root@test.local"
[root@ansible1 administrator]# git config --list --show-origin                 
file:/root/.gitconfig   user.name=root
file:/root/.gitconfig   user.email=root@test.local

git config --list

```

[Настройка проектов](https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-init)
[еще сслыка](https://qna.habr.com/q/6413)
Гит хранит файлы и историю в директории проекта

```
git --version
git config --global user.name "ansible" 
git config --global user.email ansible@test.local

git init --bare project1.git
mv project1.git/hooks/post-update.sample project1.git/hooks/post-update

git init --bare project2.git
mv project2.git/hooks/post-update.sample project2.git/hooks/post-update

cd project1.git/
git init
git status
```
Ниже видно, что файлы не отслеживаемые.
```
[root@ansible1 project1.git]# git status
На ветке master

Еще нет коммитов

Неотслеживаемые файлы:
  (используйте «git add <файл>…», чтобы добавить в то, что будет включено в коммит)
        HEAD
        config
        description
        hooks/
        info/

ничего не добавлено в коммит, но есть неотслеживаемые файлы (используйте «git add», чтобы отслеживать их)
```
Добавим все файлы через параметр `.`
```
git add .
```
Теперь эти файлы можно закоммитить. Коммит обычно называетсчя по имени или ID бага из багтрекера.
```
git commit -m "Initial Commit" -a
```

![[Pasted image 20240221125943.png]]
Тпеперь все закоммичено:
![[Pasted image 20240221130043.png]]
```
	git log
```
покажет нам кто делал какие коммиты
![[Pasted image 20240221130446.png]]

Узныть что было изменено и подготовлено для коммита, можно через 
```
git diff
```
![[Pasted image 20240221131159.png]]

Откатить незокоммиченные изменения можно через 
```
git checkout
или
git restore .
```

```

echo "TEST" > README
git add README
git commit -m "Initial Commit" -a
git branch -a
```

Теперь в VSCode можно подключать проекты:
http://192.168.48.23/git/project1.git
http://192.168.48.23/git/project2.git

## Проверка установленного ПО
```
dnf list installed | grep git
crontabs.noarch                         1.11-8.20121102git.el7         @anaconda
crypto-policies.noarch                  20200619-4.git781bbd4.el7      @anaconda
crypto-policies-scripts.noarch          20200619-4.git781bbd4.el7      @anaconda
csnappy.x86_64                          0-5.20150729gitd7bc683.el7     @anaconda
git.x86_64                              2.30.9-1.el7                   @updates 
git-core.x86_64                         2.30.9-1.el7                   @updates 
git-core-doc.noarch                     2.30.9-1.el7                   @updates 
libnsl2.x86_64                          1.2.0-5.20180605git4a062cf.el7 @anaconda
net-tools.x86_64                        2.0-0.56.20160912git.el7       @anaconda
```

## How To Use Git first time
1. https://www.digitalocean.com/community/tutorials/how-to-use-git-effectively
```
mkdir testing
cd testing

initialize a Git repository
git init

allow your existing files to be tracked by Git
git add .

create a commit. Each time you commit changes to a Git repository, you’ll need to provide a commit message. Commit messages summarize the changes that you’ve made. Commit messages can never be empty, but can be any length
git commit -m "Initial Commit" -a

to commit a single file or a few files
git commit -m "Initial Commit" file1 file2

Configure pushing changes to a remote server
git remote add origin ssh://git@git.domain.tld/repository.git 
git remote -v

Once you have a remote configured, you are able to push your code. You can push code to a remote server
git push origin main

```

## How To Use Git Branches
2. https://www.digitalocean.com/community/tutorials/how-to-use-git-branches
```
Зайдем на сервер и проверим, что там есть нового
git fetch

see all the branches
git branch -a

Modify name of current branch
git branch -m block-news

Delete branch
git checkout master
git branch -d block-news - Могут быть вопросы
git branch -D block-news - удаление без вопросов, даже если бранч не смерджен на master




to create a single branch for development - создается набор файлов аналогичный тому, в котором производится checkout
git checkout -b develop
пушим бранч в гит
git push -u origin develop

switch back and forth between your two branches - при этом в файловой системе оказываются файлы, которые соответствуют текущей ветке
git checkout master
git checkout develop

to create a new blank file, named "develop". Until we merge it to the master branch (in the following step), it will not exist there
git checkout develop
touch develop
git add develop

create a commit with message
git commit -m "develop file" develop

цивилизованный способ состоит в том, что мастер ветку обычные работники не коммитят, это делает тимлид. Обычно разработчики делают merge request или pull request (см. далее) (https://git-scm.com/book/ru/v2/GitHub-%D0%92%D0%BD%D0%B5%D1%81%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%BE%D0%B1%D1%81%D1%82%D0%B2%D0%B5%D0%BD%D0%BD%D0%BE%D0%B3%D0%BE-%D0%B2%D0%BA%D0%BB%D0%B0%D0%B4%D0%B0-%D0%B2-%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D1%8B) Запрос на принятие изменений (Pull Request) откроет новую ветвь с обсуждением отправляемого кода, и автор оригинального проекта, а так же другие его участники, могут принимать участие в обсуждении предлагаемых изменений до тех пор, пока автор проекта не будет ими доволен, после чего автор проекта может добавить предлагаемые изменения в проект.

To merging code between branches (from the develop branch to the master branch). Чтобы вмерджить ветку в мастер, нужно сначала перейти в мастер, а затем выполнить git merge branch_name. 
Переключаемся на мастер
git checkout master

Стоит почаще подтягивать мастер в свою ветку
git pull --rebase origin master 
Мерджить можно из мастера
git merge develop --no-ff

Или мерджить можно из ветки в мастер
git checkout news-redesign
git merge master

to push our changes with any changes on our remote server. После мерджа в мастер, не забывайте пушить эти изменения
git push origin master
```

## WORKFLOW
[Основные концепции работы с GIT](https://git-scm.com/book/ru/v2/GitHub-%D0%92%D0%BD%D0%B5%D1%81%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%BE%D0%B1%D1%81%D1%82%D0%B2%D0%B5%D0%BD%D0%BD%D0%BE%D0%B3%D0%BE-%D0%B2%D0%BA%D0%BB%D0%B0%D0%B4%D0%B0-%D0%B2-%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D1%8B):
GitHub разработан с прицелом на определённый рабочий процесс с использованием запросов на слияния. Этот рабочий процесс хорошо подходит всем: и маленьким, сплочённым вокруг одного репозитория, командам; и крупным распределённым компаниям, и группам незнакомцев, сотрудничающих над проектом с сотней копий. Рабочий процесс GitHub основан на [тематических ветках](https://git-scm.com/book/ru/v2/ch00/r_topic_branch), о которых мы говорили в главе [Ветвление в Git](https://git-scm.com/book/ru/v2/ch00/ch03-git-branching).

Вот как это обычно работает:
1. Создайте форк проекта.    
2. Создайте тематическую ветку на основании ветки `master`.    
3. Создайте один или несколько коммитов с изменениями, улучшающих проект.    
4. Отправьте эту ветку в ваш проект на GitHub.    
5. Откройте запрос на слияние на GitHub.    
6. Обсуждайте его, вносите изменения, если нужно.    
7. Владелец проекта принимает решение о принятии изменений, либо об их отклонении.    
8. Получите обновлённую ветку `master` и отправьте её в свой форк.

## Как работать с FORK
[описание](https://webdevkin.ru/posts/raznoe/git-fork)
```

```

## Примеры мерджа с ошибками
[Статья](После мерджа в мастер, не забывайте пушить эти изменения) - платные курсы за 2500

## Примеры развертывания GIT
[Git. Развертывание локального сервера 2022](https://rjaan.narod.ru/docs/dev/gits/git-to-deploy-own-git-server.html)
[пример](https://sethrobertson.github.io/HowToPutGitOnTheWeb/GitOnTheWeb.html)
[пример2](https://habr.com/ru/sandbox/23857/)
[Git. Коротко о главном](https://habr.com/ru/articles/588801/)
[git-http-backend on Apache 2.4](https://cweiske.de/tagebuch/apache24-git-http-backend.htm)
