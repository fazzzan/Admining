
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

Не сработало
  - block:
    - name: Start FTP service
      become: yes
      service: name=git state=restarted enabled=yes
```

sudo dnf install gitweb
mkdir ~/ansible
cp -r /var/www/git ~/testing/git

$projectroot = '/home/administrator/ansible/git';
$site_name = "ANSIBLE git trees.";

cd ansible
git init
git add .
git commit -m "Initial Commit" -a
git branch -a

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
see all the branches
git branch -a

to create a single branch for development
git checkout -b develop

switch back and forth between your two branches
git checkout master
git checkout develop

to create a new blank file, named "develop". Until we merge it to the master branch (in the following step), it will not exist there
git checkout develop
touch develop
git add develop

create a commit with message
git commit -m "develop file" develop

To merging code between branches (from the develop branch to the master branch)
git checkout master
git branch
git merge develop --no-ff

to push our changes with any changes on our remote server
git push

```

## Запуск докера
4. Запуск докера
```
docker run -d --name topdemo alpine top -b
И потом
docker attach topdemo
```

```
sudo nano /etc/resolv.conf 
```
