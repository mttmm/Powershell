#sam account requires $ at the end!
$servers = @("nuve-rdsh-edu01$", "nuve-rdsh-edu02$", "nuve-rdsh-cyp01$", "nuve-rdsh-cyp02$")

foreach ($server in $servers) {
ADD-ADGroupMember “NUVE-RDSHServers” –members $server
}