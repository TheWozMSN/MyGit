<#

.SYNOPSIS

	Update server DNS client config

.DESCRIPTION

	Long description

.EXAMPLE

	C:\etc>.\set-ipv2a.ps1

	Example of how to use this cmdlet

.NOTES

	File Name: set-ipv2a.ps1

	Date Created: 03.17.2017

	Author: dwoz

	03.17.2017 JJK: TODO: add debug output and logging

#>

Begin {

	$file = 'C:\etc\srv03sb.csv'

	$computers = Import-Csv -Path $file -Header ComputerName, IPAdress, DNSServer1, DNSServer2, DNSServer3 

	$rptfile = "c:\etc\setip-debug.txt"

}# End Begin

Process {

foreach ($computer in $computers) {

    if(Test-Connection -ComputerName $computer.ComputerName -Count 1 -ea 0) {            

        try {            

            $Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $computer.ComputerName -EA Stop | where {$_.IPEnabled}

		}

		catch {            

            Write-Warning "Error occurred while querying $computer."            

            Continue            

        } 

        foreach ($Network in $Networks) {

				#region debug

					$computer.DNSServer1 | out-file $rptfile -Append

				#endregion            

                $dns = @($computer.DNSServer1,$computer.DNSServer2)

				Try {$Network.SetDNSServerSearchOrder($dns) | Out-file $rptfile -Append}

				Catch{

					"Unable to update the DNSSearchOrder for {0}" -f $computer.ComputerName

					$error[0].exception.message

				}

                

        }          

    }

}

} #End Process