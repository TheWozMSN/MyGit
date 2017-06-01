#vscode settings for Microsoft.VSCode_profile.ps1
#[System.Console]::OutputEncoding = [System.Text.Encoding]::ASCII


Get-Process


Function Get-NetConfig {
    [CmdletBinding()]
    Param (
        $InterfaceIndex,
        $AddressFamily
    )

    $NodeName = $env:ComputerName
    $NetAdapter = Get-NetAdapter -InterfaceIndex $InterfaceIndex
    $IPconfig = Get-NetIPAddress -InterfaceIndex $InterfaceIndex -AddressFamily $AddressFamily
    $DNS = (Get-DnsClientServerAddress -InterfaceIndex $InterfaceIndex).ServerAddresses
    $obj = [PSCustomObject]@{NodeName = $NodeName; IPAddress = $IPconfig.IPAddress; MacAddress = $NetAdapter.MacAddress; DNS = $DNS}
    $obj
}

Invoke-Command -ComputerName ssdsrv108 `
    -ScriptBlock ${Function:Get-NetConfig} `
    -ArgumentList '12', 'IPV4' |
    Select-Object NodeName, IPaddress, MacAddress, DNS