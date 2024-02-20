```
---
- name: YAMLPB1
  hosts: cisco_devices
  
  vars:
    shipintbr: show ip int br
    shiparp: show ip arp
    shiproute: show ip route
    shruninte03: show run int eth 0/3
  
  
  tasks:
    - name: PB1_GET UP IP BR 
      ios_command:
        commands:
          - "{{shipintbr}}"
          
      register: VAR_shoipintbr
    -  debug: var=VAR_shoipintbr.stdout_lines    
       
 
- name: YAMLPB2
  hosts: cisco_routers367

  vars:
    shipintbr: show ip int br
    shiparp: show ip arp
    shiproute: show ip route
    shruninte03: show run int eth 0/3  
  
  tasks:
    - name: PB1_SHO IP ROUTE
      ios_command:
        commands:
          - "{{shiproute}}"
          
      register: VAR_shoiproute

    -  debug: var=VAR_shoiproute.stdout_lines          
...
```