# Specify here all the filters needed to be monitored.
$Drives = 	@{Server="localhost"; Drive ="C"},
			@{Server="localhost"; Drive ="E"}
			
# Collection to hold the report
$report = @()
foreach($drive in $Drives)
{
	# WMI Filter
	$filter = "DeviceID='" + $drive.Drive + ":'"
	
	$diskInfoWMIObject = Get-WmiObject Win32_LogicalDisk -ComputerName $drive.Server -Filter $filter | Select-Object Size,FreeSpace
	
	# Get information and create a custom reporting object.
	$driveSize = $diskInfoWMIObject.Size / 1GB
	$driveFreeSpace = $diskInfoWMIObject.FreeSpace / 1GB
	$percentageFree = [int](($driveFreeSpace * 100) / $driveSize)
	
	# Constructs a custom item 
	$reportItem = New-Object PSObject
	$reportItem | Add-Member @{ Server = $drive.Server }
	$reportItem | Add-Member @{ Drive = $drive.Drive }
	$reportItem | Add-Member @{ SizeInGb = $driveSize }
	$reportItem | Add-Member @{ FreeSpaceInGb = $driveFreeSpace }
	$reportItem | Add-Member @{ FreePercentage = $percentageFree }
	
	$report += $reportItem 
}
# Select whatever you want to display.
$report | Select-Object Server,Drive,FreePercentage