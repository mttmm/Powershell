$paths = @("\\cr02fs02\D$\Shares","\\cr02fs02\d$\Shares\Tenants","\\cr02fs02\D$\shares\tenants\cr","\\cr02fs02\d$\Shares\Tenants\CR\CRHOME","\\cr02fs02\d$\Shares\Tenants\CR\CRUSERS")

foreach ($path in $paths) {
new-item $path -ItemType directory
}