<#
.SYNOPSIS
Creates AD users from a structured CSV file and assigns them to groups.

.DESCRIPTION
Reads user data from a CSV file and creates accounts in Active Directory under floydcloud.local.
Assigns attributes like department and title, and adds users to specified groups.

.AUTHOR
Lorraine Floyd
#>

# Path to your CSV file
$csvPath = "C:\Lab\users.csv"

# Import CSV and process each user
Import-Csv -Path $csvPath | ForEach-Object {
    $name           = $_.Name
    $firstName      = $_.FirstName
    $lastName       = $_.LastName
    $samAccountName = $_.SamAccountName
    $ou             = $_.OU
    $rawPassword    = $_.Password
    $department     = $_.Department
    $title          = $_.Title
    $groups         = $_.Groups -split ";"  # Multiple groups separated by semicolon

    # Validate required fields
    if ([string]::IsNullOrWhiteSpace($name) -or
        [string]::IsNullOrWhiteSpace($samAccountName) -or
        [string]::IsNullOrWhiteSpace($ou) -or
        [string]::IsNullOrWhiteSpace($rawPassword)) {
        Write-Warning "⚠️ Skipping row due to missing required fields: Name, SamAccountName, OU, or Password."
        return
    }

    # Construct full OU path
    $userPath = "OU=$ou,OU=Users,OU=HQ,DC=floydcloud,DC=local"
    $upn = "$samAccountName@floydcloud.local"
    $password = ConvertTo-SecureString $rawPassword -AsPlainText -Force

    # Check if user already exists
    $userExists = Get-ADUser -Filter "SamAccountName -eq '$samAccountName'" -ErrorAction SilentlyContinue

    if (-not $userExists) {
        try {
            # Create the user
            New-ADUser -Name $name `
                       -GivenName $firstName `
                       -Surname $lastName `
                       -SamAccountName $samAccountName `
                       -UserPrincipalName $upn `
                       -Path $userPath `
                       -AccountPassword $password `
                       -Enabled $true `
                       -Department $department `
                       -Title $title `
                       -ChangePasswordAtLogon $true
            Write-Host "Created user: $samAccountName in $userPath"

            # Add user to groups
            foreach ($group in $groups) {
                $groupName = $group.Trim()
                if (-not [string]::IsNullOrWhiteSpace($groupName)) {
                    try {
                        Add-ADGroupMember -Identity $groupName -Members $samAccountName
                        Write-Host "   ↪ Added to group: $groupName"
                    } catch {
                        Write-Warning "Could not add $samAccountName to group $groupName. Check if group exists."
                    }
                }
            }
        } catch {
            Write-Warning "Failed to create user: $samAccountName. $_"
        }
    } else {
        Write-Host "User already exists: $samAccountName"
    }
}