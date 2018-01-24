
$servers = @("nuve-rdsh-edu01", "nuve-rdsh-edu02", "nuve-rdsh-cyp01", "nuve-rdsh-cyp02")

foreach ($server in $servers) {
get-adcomputer $server | Move-ADObject -targetpath "OU=RDSH,OU=Servers,DC=nuvestack,DC=com"
}