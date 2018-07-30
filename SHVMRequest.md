Please create the following VM using the following template: (Paste here an option from below)
     RP-TEMPLATE-WINDOWS2012R2-BASE (Windows 2012R2 Standard Edition - use this one when in doubt)
     RP-TEMPLATE-WINDOWS2012R2-MSSQL-DEV (Windows 2012R2 Standard with Microsoft SQL 2016 Developer Edition)
     RP-TEMPLATE-WINDOWS2012R2-MSSQL-PROD (Windows 2012R2 Standard with Microsoft SQL 2014 Standard Edition)
     RP-TEMPLATE-WINDOWS2012R2-DC (Windows 2012R2 Data Center Edition)
     Windows Server 2016
 
Does this VM need to be added anywhere other than "StandardVM" VM/Host Group?  Any special affinity rules required? No
     No (default answer)
     Yes (select when needing to guarantee that two nodes in a shared cluster do not reside on the same physical host)
 
Hostname: (see above for hostname naming convention)
 
vlan: (select an option below)
     rp-prod-dmz       10.21.10.1/24
     rp-prod-hosp-dmz  10.21.11.1/24
     rp-prod-inside    10.21.20.1/24
     rp-prod-sql       10.21.30.1/24
     rp-dev-sql        10.17.30.1/24
     rp-dev-dmz        10.17.10.1/24
     rp-corp-inside    10.17.100.1
     rp-prod-pub       108.178.30.161
 
IP: (select available IP from empty area in spreadsheet or IPAM.)
Domain joined?: Yes
Domain: radpartners.com
Primary DNS: 10.21.20.21
Secondary DNS: 10.21.20.22
 
Storage-level encryption (encryption at rest)?: Yes
Disaster-recovery counterpart-server required in SingleHop Phoenix, AZ? No
 
Resource specifications:
     CPU: 1 socket with 2 cores
     Ram: 8 GB
     Drive C labeled "OS" = 150GB, default block size
      
     SQL Servers:What year and version of SQL will be installed? (Ex. SQL Server 2016 Dev Edition)
          If SQL 2014 will be used, then please enable .NET 3.5 Feature in Windows 2012R2.
          If SQL 2016, RP database administrators will install.
          Drive G labeled "Data" = 150 GB, block size =64KB
          Drive L labeled "Log" = 30 GB, block size = 64KB
          Drive I labeled "Index" = 20 GB, block size = 64KB
          Drive T labeled "Tempdb" = 10 GB, block size = 64KB
          Drive U labeled "Backup" = 60 GB, block size = 64KB
 
Activate Windows against the RP WSUS server
     From elevated command line:
     slmgr -skms 10.21.10.101
     slmgr -ato
 
Install AlertLogic client
Install Antivirus client
Install any new Windows Updates since the last month the VM template was updated.
How often and when should SingleHop back up this server?
When can SingleHop patch and reboot the server?
 
For RP Infrastructure staff:
     Add the new server to the Temporary SingleHop Maintenance Spreadsheet
     Who needs remote access to this server?
     Who needs local administrator rights on this server?
     How often and when should this server be backed up?
     When can SingleHop reboot the servers?
     If SQL server, then:
          1. Add sg-sqladmins to local admin group
          2. Add sg-sqladmins to RDP.