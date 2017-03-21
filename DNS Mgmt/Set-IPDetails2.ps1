$file = 'C:\etc\srv03sb.csv'
$computers = Import-Csv -Path $file -Header ComputerName, IPAdress, DNSServer1, DNSServer2, DNSServer3 
foreach ($computer in $computers) {

begin {}            
process {            





[cmdletbinding()]            
param (            
 [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]            
    [string[]]$ComputerName = $env:computername            
)
 $Report = @()
 foreach ($Computer in $ComputerName) {            
    if(Test-Connection -ComputerName $computer.ComputerName -Count 1 -ea 0) {            
        try {            
            $Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $computer.ComputerName -EA Stop | ? {$_.IPEnabled}            
            } catch {            
            Write-Warning "Error occurred while querying $computer."            
            Continue            
            } 
            foreach ($Network in $Networks) {            
                $dns =  @()
                $dns = $computer.DNSServer1, $computer.DNSServer2
                $Network.SetDNSServerSearchOrder($dns) | Out-Null
           }          
    }
}
}
end{}