Copy remote file (host.example.com:/tmp/somefile) into folder /tmp/fetched/host.example.com/tmp/somefile on local machine
```yaml
- hosts: host.example.com
  tasks:
    # Copy remote file (host.example.com:/tmp/somefile) into
    # /tmp/fetched/host.example.com/tmp/somefile on local machine
    - fetch:
        src: /tmp/somefile
        dest: /tmp/fetched
```