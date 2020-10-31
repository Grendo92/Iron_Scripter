Function Get-WindowsRegistrationInfo {
    [cmdletbinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        #Enter computer name
        [string[]]$Computername 
    )
    begin { }#Begin

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

    End { } #End
    
}

Function Set-WindowsRegistrationInfo {
    [cmdletbinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, pa)]
        #Enter computer name
        [string[]]$Computername,
        [parameter(position = 1, Mandatory = $true, HelpMessage = "Which registered value you want to set? Owner,Organization or both?")]
        [ValidateSet("Owner", "Organization")]
        #Select which registration value you want to set.
        [String[]]$RegistrationValue

    )
    dynamicparam {
        if ($RegistrationValue -like "Owner") {
            $OwnerAttribute = New-Object System.Management.Automation.ParameterAttribute
            $OwnerAttribute.Mandatory = $True
            $OwnerAttribute.Position = 2
            $OwnerAttribute.HelpMessage = "Please enter "
            $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($OwnerAttribute)
            $OwnerParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Owner', [string], $attributeCollection)
            $paramDictionary = new-objectSystem.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add('Owner', $OwnerParam)
            return $paramDictionary
        }
        elseif($RegistrationValue -like "Organization")
        {
            $OrganizationAttribute = New-Object System.Management.Automation.ParameterAttribute
            $OrganizationAttribute.Mandatory = $True
            $OrganizationAttribute.Position = 2
            $OrganizationAttribute.HelpMessage = "Please enter "
            $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($OrganizationAttribute)
            $OwnerParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Organization', [string], $attributeCollection)
            $paramDictionary = new-objectSystem.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add('Owner', $OwnerParam)
            return $paramDictionary
        }
    }
    begin {
        $Keypath = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion'
        $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Computer)
        $key = $reg.OpenSubKey($Keypath)

    }

    process { }
       

        

}
}

