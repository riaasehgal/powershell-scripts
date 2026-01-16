$logFolder = "C:\Logs"
if (-not (Test-Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder -Force
}

function Write-DailyLog {
    param (
        [string]$Message
    )
    $date = Get-Date -Format "yyyy-MM-dd"
    $dailyLog = Join-Path $logFolder "Lab1_$date.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $dailyLog -Value "$timestamp - $Message"
}

while ($true) { 
    #CPU
    $cpu= (Get-Counter '\Processor (Total) \% Processor Time'). Counter Samples.CookedValue

    if (Scpu-gt 80){
        Write-Host "CPU is HIGH! $cpu 96"
    }
    #Memory
    $mem = Get-CimInstance Win32_OperatingSystem
    $usedMem= ((Smem. TotalvisibleMemorySize Smen. FreePhysicalMemory) / Smem.TotalvisibleMemorySize) 100 
    if ($usedMem -gt 85){
        Write-Host "warning: Memory usage is $usedMem.2 %"

    }
    #Disk
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C: '"
    $freeDisk = ($disk. FreeSpace / $disk. Size) = 100
    if ($freeDisk -lt 15){
        Write-Host "Critical: C: drive is low $([math]::Round($freeDisk, 2)) %% free"
    }
    Start-sleep -Seconds 5
}