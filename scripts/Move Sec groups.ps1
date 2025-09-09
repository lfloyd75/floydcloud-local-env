# Define target OU
$targetOU = "OU=Security,OU=Groups,OU=HQ,DC=floydcloud,DC=local"

# List of group names to move
$groups = @(
    "GG-App-Reports-Readers",
    "GG-App-SalesPortal-Users",
    "GG-Helpdesk-PasswordReset",
    "GG-Server-Admins",
    "GG-Workstation-Admins"
)

# Loop through each group and move it
foreach ($group in $groups) {
    $groupDN = (Get-ADGroup -Identity $group).DistinguishedName
    Move-ADObject -Identity $groupDN -TargetPath $targetOU
    Write-Host "Moved $group to $targetOU"
}
