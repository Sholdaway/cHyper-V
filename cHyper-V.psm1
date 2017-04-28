[DscResource()]
class cVMQConfig
{
    [DscProperty(Key)]
    [string]$Interface

    [DscProperty(Mandatory)]
    [System.UInt32]$BaseProcessorNumber

    [DscProperty(Mandatory)]
    [System.UInt32]$MaxProcessors
    
    [DscProperty(Mandatory)]
    [System.UInt32]$MaxProcessorNumber

    [void] Set()
    {
        $SetVmqArgs = @{Name = $this.Interface
                        BaseProcessorNumber = $this.BaseProcessorNumber
                        MaxProcessors = $this.MaxProcessors
                        MaxProcessorNumber = $this.MaxProcessorNumber}

        try {

        Set-NetAdapterVmq @SetVmqArgs

        }
        catch {

        Write-Verbose "Failed to set VMQ settings on: $($this.Interface)"
        #If this is a void method should I even be returning an error object?
        $Error[0].Exception.Message

        }
    }


    [bool] Test() 
    {
        $InterfaceConfig = Get-NetAdapterVmq -Name $this.Interface
      
        if ($this.Interface -ne ($InterfaceConfig).Name) 
        {
            Write-Verbose "Interface name is not compliant"
            return $False
        }

        elseif ($this.BaseProcessorNumber -ne ($InterfaceConfig).BaseProcessorNumber) 
        {
            Write-Verbose "Base processor number is not compliant"
            return $False
        }
        
        elseif ($this.MaxProcessors -ne ($InterfaceConfig).MaxProcessors) 
        {
            Write-Verbose "Max processors is not compliant"
            return $False
        }

        elseif ($this.MaxProcessorNumber -ne ($InterfaceConfig).MaxProcessorNumber) 
        {
            Write-Verbose "Max processor number is not compliant"
            return $False
        }

        else 
        {
            return $True
        } 

    }

    [cVMQConfig] Get()
    {

        $ReturnValue = @{Interface = (Get-NetAdapterVmq -Name $this.Interface).Name
                         BaseProcessorNumber = (Get-NetAdapterVmq -Name $this.Interface).BaseProcessorNumber
                         MaxProcessors = (Get-NetAdapterVmq -Name $this.Interface).MaxProcessors
                         MaxProcessorNumber = (Get-NetAdapterVmq -Name $this.Interface).MaxProcessorNumber}

        return $ReturnValue
    }

}




[DscResource()]
class cHVLiveMigration 
{
    [DscProperty(Key)]
    [System.UInt32]$MigrationThreshold

    [void] Set()
    {
        Set-VMHost -MaximumVirtualMachineMigrations $This.MigrationThreshold
    }


    [bool] Test() 
    {
        $LiveMigrationTheshold = Get-VMHost | Select-Object -ExpandProperty MaximumVirtualMachineMigrations

        if ($LiveMigrationTheshold -eq $This.MigrationThreshold) 
        {
            Write-Verbose ("Current Live Migration threshold is compliant, setting is: " + $LiveMigrationTheshold)
            return $True
        }
        else
        {
            Write-Verbose ("Current Live Migration threshold is not compliant, setting is: " + $LiveMigrationTheshold)
            return $False
        }
    }

    [cHVLiveMigration] Get()
    {
        $ReturnValue = @{
                    MigrationThreshold = Get-VMHost | Select-Object -ExpandProperty MaximumVirtualMachineMigrations
                    }

        return $ReturnValue
    }
}

