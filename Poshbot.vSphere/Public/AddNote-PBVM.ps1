function Start-PBVM {
    <#
    .SYNOPSIS
        PoshBot command to start VM.
    .EXAMPLE
        !startvm vm1
    #>
    [PoshBot.BotCommand(CommandName = 'startvm')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $true, ValueFromRemainingArguments = $true)]
        [string[]]$vm
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($vm) {
        $objects = Get-VM fritz-001 | Set-VM -Notes "last updated $(Get-Date)" -confirm:$false
    }
    else {
        exit
    }

    $ResponseSplat = @{
        Text = Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    Disconnect-Viserver -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
