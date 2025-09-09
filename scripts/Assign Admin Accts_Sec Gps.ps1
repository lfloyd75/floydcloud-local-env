<#
.SYNOPSIS
Adds admin and service accounts to existing security groups in floydcloud.local.

.DESCRIPTION
This script assigns privileged accounts to their respective security groups for role-based access control.

.AUTHOR
Lorraine Floyd
#>

# Define account-to-group mappings
$assignments = @(
    @{User="adm-lfloyd"; Group="GG-DomainAdmins"},
    @{User="svc-backup"; Group="GG-Server-Admins"},
    @{User="svc-monitoring"; Group="GG-Server-Admins"},
    @{User="adm-helpdesk"; Group="GG-Helpdesk-PasswordReset"},
    @{User="adm-helpdesk"; Group="GG-Workstation-Admins"}
)

foreach ($entry in $assignments) {
    try {
        $user = Get-ADUser -Identity $entry.User
        $group = Get-ADGroup -Identity $entry.Group

        Add-ADGroupMember -Identity $group -Members $user
        Write-Host "Added $($entry.User) to $($entry.Group)"
    } catch {
        Write-Warning "Failed to add $($entry.User) to $($entry.Group). Check if both exist."
    }
}