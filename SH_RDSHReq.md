Please create 8 VMs using the following template:
     
     Windows Server 2016
 
Does this VM need to be added anywhere other than "StandardVM" VM/Host Group?  Any special affinity rules required? No
    
     Yes - place the machines on node12.rds.chi03.radpartners.com
        Enable Flash Read Cache on 30GB for each VM
 
Hostname: PRPMCRDSH01 - 10.21.20.69
        PRPMCRDSH02  - 10.21.20.70
        PRPMCRDSH03 - 10.21.20.71
        PRPMCRDSH04 - 10.21.20.72
        PRPMCRDSH05 - 10.21.20.73

        PRPMCRA01 - 10.21.20.74
        PRPMCRA02 - 10.21.20.75
        PRPMCRA03 - 10.21.20.76

 


vlan:
     
     rp-prod-inside    10.21.20.1/24
     
 
IP: Listed above
Domain joined?: Yes
Domain: radpartners.com
Primary DNS: 10.21.20.21
Secondary DNS: 10.21.20.22
 
 
Resource specifications:
     CPU: 1 socket with 4 cores
     Ram: 32 GB
     Drive C labeled "OS" = 150GB, default block size
     Allocate 30GB for Flash Read Cache for each VM
      
 
Activate Windows against the RP WSUS server
     From elevated command line:
     slmgr -skms 10.21.10.101
     slmgr -ato
 
Install AlertLogic client
Install Antivirus client
Install any new Windows Updates since the last month the VM template was updated.