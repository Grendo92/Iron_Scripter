Function Get-WindowsRegistrationInfo {
    [cmdletbinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        #Enter computer name
        [string[]]$Computername 
    )
    begin {}#Begin

    Process {
        foreach ($Computer in $Computername) {
            
            $Keypath = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion'
            $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Computer)  
            $key = $reg.OpenSubKey($Keypath) 

            $RegistrationInfo = [PSCustomObject]@{
                Organization = $key.GetValue('RegisteredOrganization')
                Owner        = $key.GetValue('RegisteredOwner')
                Computer     = $computer
            } 
            Write-Output $RegistrationInfo 
            
        }#Foreach
    }#Process

    End {} #End
    
}

Function Set-WindowsRegistrationInfo{
    [cmdletbinding()]
    param(
        [parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        #Enter computer name
        [string[]]$Computername,
        [parameter(position=1,Mandatory=$true,HelpMessage="Which registered value you want to set? Owner,Organization or both?")]
        [ValidateSet("Owner","Organization")]
        #Select which registration value you want to set.
        [String[]]$RegistrationValue

    )
    begin{
        $Keypath = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion'
        $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Computer)
        $key = $reg.OpenSubKey($Keypath)
    }
}

