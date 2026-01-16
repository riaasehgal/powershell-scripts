$logFile = "C:\Temp\Lab1_Log.txt" # Logs all events to C:\Temp\Lab1_Log.txt

while ($true) {

    #CPU 
    $cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $cpu = [math]::Round(($cpu -as [double]), 2)

    if ($cpu -gt 80) {
        $msg = "$(Get-Date) CPU high: $cpu %"
        Write-Host $msg
        Add-Content $logFile $msg

        $top = (Get-Counter '\Process(*)\% Processor Time').CounterSamples |
            Where-Object { $_.InstanceName -notmatch "^(idle|_total|system|searchprotocolhost|svchost|services|lsass|csrss)$" } |
            Sort-Object CookedValue -Descending |
            Select-Object -First 1

        if ($top) {
            $pname = $top.InstanceName
            $proc = Get-Process -Name $pname -ErrorAction SilentlyContinue | Select-Object -First 1

            if ($proc) {
                try {
                    Stop-Process -Id $proc.Id -Force -ErrorAction Stop
                    Add-Content $logFile "$(Get-Date) Killed $($proc.ProcessName) (PID $($proc.Id))"
                } catch {
                    Add-Content $logFile "$(Get-Date) Failed to kill $pname (PID $($proc.Id)): $($_.Exception.Message)"
                }
            }
        }
    }

    #Memory
    $mem = Get-CimInstance Win32_OperatingSystem
    $usedMem = (($mem.TotalVisibleMemorySize - $mem.FreePhysicalMemory) / $mem.TotalVisibleMemorySize) * 100
    $usedMem = [math]::Round($usedMem, 2)

    if ($usedMem -gt 70) {
        $msg = "$(Get-Date) Memory high: $usedMem %"
        Write-Host $msg
        Add-Content $logFile $msg

        $p = Get-Process | Sort-Object WS -Descending | Select-Object -First 1
        Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
        Add-Content $logFile "$(Get-Date) Tried to kill $($p.Name) (PID $($p.Id)). Investigate."
    }

    #Disk
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $free = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2)

    if ($free -lt 15) {
        $msg = "$(Get-Date) Disk low: $free % free"
        Write-Host $msg
        Add-Content $logFile $msg

        Remove-Item "C:\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
        Add-Content $logFile "$(Get-Date) Cleared C:\Temp"
    }

    Start-Sleep -Seconds 60
}
