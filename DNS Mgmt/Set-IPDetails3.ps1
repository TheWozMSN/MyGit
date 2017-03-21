
#$myfile = "C:\etc\srv03sb.csv"


Function Set-IPDetails{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
                   #HelpMessage="The Computer Name")]
                      
        [string]$ComputerName,
        [string]$IPAdress,
        [String]$DNS1,
        [String]$DNS2,
        [string]$DNS3
    )

    BEGIN{}
    PROCESS{

        try {            
            $Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $($computer.ComputerName) -ErrorAction Stop | ? {$_.IPEnabled and }            
            foreach ($Network in $Networks) {            
                $dns =  @()
                $dns = $($computer.DNSServer1), $($computer.DNSServer2)
                $Network.SetDNSServerSearchOrder($dns) | Out-Null
                Write-Output "Set $($computer.ComputerName) DNS Servers to $($computer.DNSServer1) and $($computer.DNSServer2)"
            }
        } 
        catch {            
            Write-Warning "Error occurred while querying $($computer.ComputerName)"            
        } 
    }
   END{}
    
}
#>