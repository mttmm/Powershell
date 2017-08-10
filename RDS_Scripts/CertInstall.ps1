Get-ADComputer -LDAPFilter "(name=*CB*)" -SearchBase 'OU=RDSH Infra,OU=Servers,DC=nuvestack,DC=com' |
    foreach {
  $brok = $_.DNSHostname 
$rdha = Get-RDConnectionBrokerHighAvailability -ConnectionBroker $brok
$rdha
    }







    Get-ADComputer -LDAPFilter "(name=*CB*)" -SearchBase 'OU=RDSH Infra,OU=Servers,DC=nuvestack,DC=com' | Select-Object DNSHostname | 
    foreach {
    
$rdha = Get-RDConnectionBrokerHighAvailability -ConnectionBroker nuve-rdcb01.nuvestack.com $broker
$rdha
    }

$rdsh = Get-ADComputer -LDAPFilter "(name=*RDSH*)" -SearchBase 'OU=RDSH,OU=Servers,DC=nuvestack,DC=com' | Select-Object DNSHostname |
    foreach {
        
    }