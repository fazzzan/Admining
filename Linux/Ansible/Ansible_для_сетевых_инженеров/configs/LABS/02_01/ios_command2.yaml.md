```
---
- name: Running show commands on Cisco IOS
  hosts: R1
  gather_facts: false
  connection: network_cli

  tasks:
    - name: Run multiple commands on Cisco IOS XE nodes
      ios_command:
        commands:
          - show clock
          - show ver | in uptime

      register: print_output

    - name: Debug registered var
      debug: var=print_output.stdout_lines
...
```