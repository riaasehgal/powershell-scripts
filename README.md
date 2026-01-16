# PowerShell Scripts Repository – Lab1 Monitoring

This repository contains **PowerShell scripts developed by Riaa Sehgal** as part of the **Windows Administration (INFO33192)** course. These scripts demonstrate **system resource monitoring**, **security event tracking**, and **automation of administrative tasks** using PowerShell.

---

## Repository Contents

The repository includes the following scripts:

| Script Name | Purpose |
|-------------|---------|
| `SysHealthLogger.ps1` | Monitors **CPU, memory, and disk usage**, logs messages to **daily log files** in `C:\Logs`. |
| `SecurityMonitor.ps1` | Tracks **failed logons**, **account lockouts**, and **unexpected service stops**, writes alerts to a **custom event log** (`Lab1-Monitoring`) and the console. |
| `ResourceAlert.ps1` | Continuously monitors **CPU, memory, and disk**, **kills high-resource processes**, cleans temp files, and logs actions to `C:\Temp\Lab1_Log.txt`. |

---

## Purpose

This project aims to:

- Practice and demonstrate **Windows administration and monitoring skills** using PowerShell.
- Automate **system and security monitoring tasks**.
- Learn best practices for **PowerShell scripting**, including logging, loops, error handling, and event management.
- Prepare scripts for **academic evaluation** and **practical application** in IT environments.

> Each script is **independent** and can be executed directly in PowerShell.

---

## Usage

1. Clone this repository to your local machine:

```powershell
git clone https://github.com/riaasehgal/powershell-scripts.git
```
2. Open PowerShell and navigate to the repository folder:
```
cd powershell-scripts

# For system health monitoring
.\SysHealthLogger.ps1

# For security monitoring
.\SecurityMonitor.ps1

# For automated resource alerts
.\ResourceAlert.ps1
```

## Check Logs

- **SysHealthLogger.ps1** → Daily log files in `C:\Logs\Lab1_YYYY-MM-DD.log`  
- **SecurityMonitor.ps1** → Custom event log `Lab1-Monitoring` (viewable in Event Viewer)  
- **ResourceAlert.ps1** → Log file `C:\Temp\Lab1_Log.txt`  

---

## Notes

- Scripts **run continuously in a loop**; stop them using `Ctrl + C`.  
- `ResourceAlert.ps1` may **kill processes or clear temporary files**—use with caution.  
- **Administrator privileges** are required for `SecurityMonitor.ps1` to read Security Event Logs and create a custom event log source.


