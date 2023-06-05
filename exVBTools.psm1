Function Get-DoNotUpgrade {
    try{
        $DoNotUpgrade = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Wow6432Node\Visma\Visma Business\CurrentVersion\Database\' -Name DO_NOT_UPGRADE -ErrorAction Stop
    }
    Catch [System.Management.Automation.ItemNotFoundException]{
        Write-Host ("DO_NOT_UPGRADE eksisterer ikke")
        New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Visma\Visma Business\CurrentVersion\Database\' -Force
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Visma\Visma Business\CurrentVersion\Database\' -Name DO_NOT_UPGRADE -Value 0 -Force
    }

    if ($DoNotUpgrade -eq 0)
    {
        Write-Output "Do_Not_Upgrade er disablet"
    }
    if ($DoNotUpgrade -eq 1)
    {
        Write-Output "Do_Not_Upgrade er enablet"
    }
}
Function Set-DoNotUpgrade {
    param (
        [Parameter()]
        [switch] $on,
        [switch] $off
    )
    if ($on.IsPresent)
    {
        Set-ItemProperty -Path "HKLM:\Software\WOW6432Node\Visma\Visma Business\CurrentVersion\Database" -Name "DO_NOT_UPGRADE" -Value "1"
        Write-Output "DO_NOT_UPGRADE er enablet"
    }
    if ($off.IsPresent)
    {
        Set-ItemProperty -Path "HKLM:\Software\WOW6432Node\Visma\Visma Business\CurrentVersion\Database" -Name "DO_NOT_UPGRADE" -Value "0"
        Write-Output "DO_NOT_UPGRADE er disablet"
    }
}

function restart-vdc {
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "Insufficient permissions to run this script. Open the PowerShell console as an administrator and run this script again."
Break
}
    $services = "VismaCloudAgent", "VismaBusinessServicesHost", "VismaWorkflowServerService", "VismaWorkflowServerAutoimportService", "VismaWorkflowServerAutoinvoiceService", "VismaWorkflowServerDocumentCountService", "VismaWorkflowServerODBridgeService"
    $stoppet = @()
    
    foreach ($service in $services)
    {
        Write-Output ("Stopper $service")
        Stop-Service -Name $service -ErrorAction SilentlyContinue
        $stoppet += $service
    }
    
    foreach ($stopp in $stoppet)
    {
        Write-Output ("Starter $stopp")
        Start-Service -Name $stopp -ErrorAction SilentlyContinue
    }
}