<#
.SYNOPSIS
Creates shared folders on the file server

.DESCRIPTION
This script creates shared folders on the file server for HR  and Sales Teams.

.AUTHOR
Lorraine Floyd
#>

# Create the folders
New-Item -Path "C:\Shares\HRDocs" -ItemType Directory
New-Item -Path "C:\Shares\SalesDocs" -ItemType Directory

#Create SMB Shares
New-SmbShare -Name "HRDocs" -Path "C:\Shares\HRDocs" -FullAccess "GG-HR-Users"
New-SmbShare -Name "SalesDocs" -Path "C:\Shares\SalesDocs" -FullAccess "GG-App-SalesPortal-Users"