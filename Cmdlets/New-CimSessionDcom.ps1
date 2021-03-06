﻿function New-CimSessionDcom
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName = 'localhost',
        
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    begin
    {
        $parameters = @{
            SessionOption = (New-CimSessionOption -Protocol Dcom);
            ComputerName = $ComputerName;
        }
        if($PSBoundParameters['Credential']) {
            $parameters['Credential'] = $Credential
        }
    }

    process
    {
        New-CimSession @parameters -ErrorAction SilentlyContinue -ErrorVariable err
        $err | ForEach-Object {
            Write-Warning "Error accessing RPC server on $($_.OriginInfo.PSComputerName)"
        }
    }
}