Function Assert-UserHasPermissionToRemoteSMBFolder([string] $HostName, [string] $ShareName, [string] $AccountName)
{
	#TODO: Validate type of permission. 
	$permissions = Invoke-Command -ComputerName $HostName -ScriptBlock { `
		Get-SmbShareAccess -Name $args[0] 
	} -ArgumentList $ShareName
	
	$count = $permissions | where {$_.AccountName.ToUpperInvariant().Equals($AccountName.ToUpperInvariant()) } | measure 
	
	($count.Count -eq 1)
	
}