$logName = 'Lab1-Monitoring'
$source = 'Lab1-Monitoring'

if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
    New-EventLog -LogName $logName -Source $source
    Write-Host "Created custom log '$logName' with source '$source'"
} else {
    Write-Host "Using log '$logName' with source '$source'"
}

while ($true) {

    #Monitor Failed Logons (Event ID 4625)
    $failedEvents = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} -MaxEvents 3 -ErrorAction SilentlyContinue
    foreach ($event in $failedEvents) {
        $user = $event.Properties[5].Value
        $time = $event.TimeCreated
        $msg = "Failed login detected for user $user at $time"

        Write-EventLog -LogName $logName -Source $source -EntryType Warning -EventId 9001 -Message $msg
        Write-Host "[SECURITY ALERT] Multiple failed login attempts detected for user: $user, identified by Riaa Sehgal 991723834 on $time"
    }

    #Monitor Account Lockouts (Event ID 4740)
    $lockoutEvents = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4740} -MaxEvents 3 -ErrorAction SilentlyContinue
    foreach ($event in $lockoutEvents) {
        $user = $event.Properties[0].Value
        $time = $event.TimeCreated
        $msg = "Account lockout detected for user $user at $time"

        Write-EventLog -LogName $logName -Source $source -EntryType Error -EventId 9002 -Message $msg
        Write-Host "[SECURITY ALERT] Account lockout detected for user: $user, identified by Riaa Sehgal 991723834 on $time"
    }

    #Monitor Unexpected Service Stops (Event ID 7036)
    $serviceEvents = Get-WinEvent -FilterHashtable @{LogName='System'; Id=7036} -MaxEvents 3 -ErrorAction SilentlyContinue
    foreach ($event in $serviceEvents) {
        $service = $event.Properties[0].Value
        $status = $event.Properties[1].Value
        $time = $event.TimeCreated

        if ($status -eq "stopped") {
            $msg = "Unexpected service stop detected: $service stopped at $time"

            Write-EventLog -LogName $logName -Source $source -EntryType Error -EventId 9003 -Message $msg
            Write-Host "[SECURITY ALERT] Unexpected service stop detected: $service, identified by Riaa Sehgal 991723834 on $time"
        }
    }

    Start-Sleep -Seconds 60
}
