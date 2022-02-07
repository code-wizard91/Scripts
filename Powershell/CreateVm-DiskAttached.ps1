$rgName = 'POC-Resource-Group'
$vmName = 'POCVM'
$location = 'North Europe'
$storageType = 'Premium_LRS'
$dataDiskName = 'poc_datadisk1'


New-AzResourceGroup -Name $rgName -Location $location
$diskConfig = New-AzDiskConfig -SkuName $storageType -Location $location -CreateOption Empty -DiskSizeGB 10
$dataDisk1 = New-AzDisk -DiskName $dataDiskName -Disk $diskConfig -ResourceGroupName $rgName

New-AzVm `
    -ResourceGroupName $rgName `
    -Name $vmName `
    -Location $location `
    -VirtualNetworkName 'pocvnet' `
    -SubnetName 'pocSubnet' `
    -SecurityGroupName 'pocNetworkSecurityGroup' `
    -PublicIpAddressName 'pocPublicIpAddress' `
    -OpenPorts 80,3389 `
    -Image Win2019Datacenter



$vm = Get-AzVM -Name $vmName -ResourceGroupName $rgName
$vm = Add-AzVMDataDisk -VM $vm -Name $dataDiskName -CreateOption Attach -ManagedDiskId $dataDisk1.Id -Lun 1

Update-AzVM -VM $vm -ResourceGroupName $rgName

$pubIP = Get-AzPublicIpAddress -Name pocPublicIpAddress | Select-Object IpAddress

mstsc /v$pubIP:3389
