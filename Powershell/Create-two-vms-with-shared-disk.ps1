$resourceGroup="VmSharedDiskRG"
$location="uk south"
$cred = Get-Credential
$subscription="8d62c369-5e88-4b7f-9ccc-6785920af829"


Set-AzContext -Subscription $subscription
New-AzResourceGroup -Name $resourceGroup -Location $location

## Create shared disk

$dataDiskConfig = New-AzDiskConfig -Location 'uksouth' -DiskSizeGB 1024 -AccountType Premium_LRS -CreateOption Empty -MaxSharesCount 2
New-AzDisk -ResourceGroupName $resourceGroup -DiskName 'mySharedDisk' -Disk $dataDiskConfig

## Create First VM

$vm = New-AzVm -ResourceGroupName $resourceGroup -Name "myVM" -Location $location -VirtualNetworkName "myVnet" -SubnetName "mySubnet" -SecurityGroupName "myNetworkSecurityGroup" -PublicIpAddressName "myPublicIpAddress" -Credential $cred

## Get disk context and store in var 

$dataDisk = Get-AzDisk -ResourceGroupName $resourceGroup -DiskName "mySharedDisk"

## Attach disk to vm1

$vm = Add-AzVMDataDisk -VM $vm -Name "mySharedDisk" -CreateOption Attach -ManagedDiskId $dataDisk.Id -Lun 0


## create Second VM


$vm2 = New-AzVm -ResourceGroupName $resourceGroup -Name "myVM2" -Location $location -VirtualNetworkName "myVnet" -SubnetName "mySubnet" -SecurityGroupName "myNetworkSecurityGroupvmtwo" -PublicIpAddressName "myPublicIpAddressvmtwo" -Credential $cred

## Attach disk to second vm

$vm2 = Add-AzVMDataDisk -VM $vm2 -Name "mySharedDisk" -CreateOption Attach -ManagedDiskId $dataDisk.Id -Lun 0

## Get Vm context and store in vars

$vm01 = Get-AzVM -ResourceGroupName $resourceGroup -Name "myVM"
$vm02 = Get-AzVM -ResourceGroupName $resourceGroup -Name "myVM2"

## Stop Both VM's

Stop-AzVM -Name “myVM” -ResourceGroupName $resourceGroup
Stop-AzVM -Name “myVM2” -ResourceGroupName $resourceGroup

## Apply changes to both VMS

update-AzVm -VM $vm01 -ResourceGroupName $resourceGroup
update-AzVm -VM $vm02 -ResourceGroupName $resourceGroup


## Start Vm's

Start-AzVM -Name “myVM” -ResourceGroupName $resourceGroup
Start-AzVM -Name “myVM2” -ResourceGroupName $resourceGroupAZ