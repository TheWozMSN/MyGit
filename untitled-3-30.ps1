Begin {
    $reportFile = "c:\etc\SRV03-DiskFree.csv"
    $Report = @()
    $ErrorActionPreference = "SilentlyContinue"
    try { Import-Module virtualmachinemanager } catch { "Opps. Can't locate module. Exiting";exit}
    #?? this nest line.  Outside?  Make this a function and pass the servers ????
    $Servers =(Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*' -and Name -Like '*SRV03'}).name
    $ConvertToGB = (1024 * 1024 * 1024)
}

Process {
        ForEach ($Server in $Servers) {

            Try {
            $disk = Get-WmiObject Win32_LogicalDisk -ComputerName $Server -Filter "DeviceID='D:'" | Select-Object Size,FreeSpace
            }
            Catch{}

            
            $VMHost = Get-VMMServer ssdsrv15.ssd.com | Get-VM $server
            Try {
            $hostdisk = Get-WmiObject Win32_LogicalDisk -ComputerName $vmhost.HostName -Filter "DeviceID='D:'" | Select-Object Size,FreeSpace
            }
            Catch{}

            $curobj = New-Object PSObject -Property ([ordered]@{
             Server = $Server
             "VM Capacity (GB)" = [Math]::round(($disk.Size / $ConvertToGB), 3)
             "VM FreeDisk (GB)" = [Math]::round(($disk.FreeSpace / $ConvertToGB), 3)
             Host = $VMHost.hostname
             "Host Capacity (GB)" = [Math]::round(($hostdisk.Size / $ConvertToGB), 3)
             "Host FreeDisk (GB)" = [Math]::round(($hostdisk.FreeSpace / $ConvertToGB), 3)
            }) # | Select-object Server, VM Capacity (GB), VM FreeDisk (GB), Host, Host Capacity (GB), Host FreeDisk (GB) 
             
        
            $Report += $curobj
            }
}

End {
    # Export resulting report
    $Report | Export-Csv -LiteralPath $reportFile -Force -NoTypeInformation
    invoke-item -LiteralPath $reportFile
}