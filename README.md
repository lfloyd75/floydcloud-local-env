# FloydCloud On-Prem Lab Environment

This project simulates a foundational on-premises enterprise environment using Windows Server and Active Directory. Built as part of my Server & Cloud Administration training, 
it serves as a hands-on lab for exploring identity management, group policy, automation, and infrastructure design.

---

## Lab Overview

- **Domain Name**: `floydcloud.local`
- **Virtual Machines**:
  - `DC01` – Domain Controller (AD DS, DNS, Server Manager)
  - `SRV01` – Member Server (File Services, future roles)
  - `CLIENT01` – Domain-joined workstation

---

## Active Directory Structure

---

## Security Groups

The following security groups are used to manage access and delegation:

- `GG-App-Reports-Readers`
- `GG-App-SalesPortal-Users`
- `GG-Helpdesk-PasswordReset`
- `GG-Server-Admins`
- `GG-Workstation-Admins`

These are organized under `OU=Security,OU=Groups,OU=HQ,DC=floydcloud,DC=local`.

---

## Automation Scripts

PowerShell scripts are used to:
- Create and move AD objects (users, groups)
- Apply OU structure
- Delegate permissions
- Configure GPOs and drive mappings

> Scripts are modular and designed for iterative expansion as the lab evolves.

---

## Learning Objectives

- Practice AD DS administration and OU design
- Simulate real-world GPO deployment and delegation
- Explore automation with PowerShell
- Build a portfolio-ready infrastructure for cloud governance scenarios

---

## Next Steps

- Add File Server role and shared folders
- Configure GPOs for password policy, desktop settings, and drive mapping
- Integrate Windows Admin Center for centralized management
- Expand with DHCP, WSUS, or hybrid identity (Azure AD Connect)

---

## Repo Structure
