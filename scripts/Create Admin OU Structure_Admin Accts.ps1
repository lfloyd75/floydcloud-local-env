<#
.SYNOPSIS
Creates Admin OU structure and privileged accounts in floydcloud.local.

.DESCRIPTION
This script sets up a tiered Admins OU and adds key service/admin accounts. Security groups are assumed to be pre-created and managed separately.

.AUTHOR
Lorraine Floyd
#>

# Define base DN
$baseDN = "OU=Admin,OU=HQ,DC=floydcloud,DC=local"

# Create Admin OU structure
$ouList = @("Tier0", "Tier1", "Tier2")

foreach ($ou in $ouList) {
    $ouPath = "OU=$ou,$baseDN"
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ou'" -SearchBase $baseDN -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $ou -Path $baseDN
        Write-Host "Created OU: $ouPath"
    } else {
        Write-Host "OU already exists: $ouPath"
    }
}

# Create Admin Accounts
$adminAccounts = @(
    @{Name="adm-lfloyd"; OU="Tier0"; Desc="Primary domain admin account"},
    @{Name="svc-backup"; OU="Tier1"; Desc="Service account for backups"},
    @{Name="svc-monitoring"; OU="Tier1"; Desc="Service account for monitoring"},
    @{Name="adm-helpdesk"; OU="Tier2"; Desc="Helpdesk admin account"}
)

foreach ($acct in $adminAccounts) {
    $userPath = "OU=$($acct.OU),$baseDN"
    $upn = "$($acct.Name)@floydcloud.local"
    $password = ConvertTo-SecureString "P@ssword123!" -AsPlainText -Force

    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($acct.Name)'" -SearchBase $userPath -ErrorAction SilentlyContinue)) {
        New-ADUser -Name $acct.Name `
                   -SamAccountName $acct.Name `
                   -UserPrincipalName $upn `
                   -Path $userPath `
                   -AccountPassword $password `
                   -Enabled $true `
                   -Description $acct.Desc
        Write-Host "Created account: $($acct.Name) in $userPath"
    } else {
        Write-Host "Account already exists: $($acct.Name)"
    }
}