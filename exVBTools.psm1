Function Get-DoNotUpgrade {
    $DoNotUpgrade = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Wow6432Node\Visma\Visma Business\CurrentVersion\Database\' -Name DO_NOT_UPGRADE

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