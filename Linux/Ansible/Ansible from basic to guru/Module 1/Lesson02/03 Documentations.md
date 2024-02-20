Тэги: #ansible #reboot #uptime
Ссылки: 

## Ansible-doc
Это не просто модуль, это документация обо всем.
```ansible-doc [-t module] -l``` - отобразит список всех модулей текущей версии ANSIBLE

> [!question]- ```ansible-doc module - отобразит информацию по конкретному модулю текущей версии ANSIBLE с примерами``` >
>  ```
>administrator@admin-UB01:~$ ansible-doc vmware.vmware_rest.vcenter_vm_hardware_ethernet
> VMWARE.VMWARE_REST.VCENTER_VM_HARDWARE_ETHERNET    (/usr/local/lib/python3.10/dist-packages/ansible_collections/vmware/vmware_rest/plugins/mo>
>
>        Adds a virtual Ethernet adapter to the virtual machine.
>
>ADDED IN: version 0.1.0 of vmware.vmware_rest
>
>OPTIONS (= is mandatory):
>
>- allow_guest_control
>        Flag indicating whether the guest can connect and disconnect the device.
>        default: null
>        type: bool
>
>- backing
>      Physical resource backing for the virtual Ethernet adapter. Required with `state=['present']'
>        Valid attributes are:
>         - `type' (str): The `backing_type' defines the valid backing types for a virtual Ethernet adapter.
>        (['present'])
>           This key is required with ['present'].
>           - Accepted values:
>             - DISTRIBUTED_PORTGROUP
>             - HOST_DEVICE
>             - OPAQUE_NETWORK
>             - STANDARD_PORTGROUP
>```

Самой первой строчкой будет ссылка на скрипт python,  описывающий необходимые действия. В скрипте мы можем найти необходимые аргументы/опции с которыми мы можем запускать данный модуль.
