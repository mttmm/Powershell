$paths = @("\\TONFS01\D$\Shares","\\TONFS01\d$\Shares\Tenants","\\TONFS01\d$\Shares\Tenants\HOME","\\TONFS01\d$\Shares\Tenants\USERS")

foreach ($path in $paths) {
new-item $path -ItemType directory
}