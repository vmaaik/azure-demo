<#
 .SYNOPSIS
    Deploys an Always On Availability Group 

 .DESCRIPTION
    2 SQL Servers + FSW, 2 Domain Controllers, Test VM (optional)
	Optionally VM for testing purpouses can be deployed and added to existing domain.

 .PARAMETER subscriptionId
    The subscription id where the template will be deployed.

 .PARAMETER resourceGroupName
    The resource group where the template will be deployed. Can be the name of an existing or a new resource group.

 .PARAMETER resourceGroupLocation
    Optional, a resource group location. If specified, will try to create a new resource group in this location. If not specified, assumes resource group is existing.

 .PARAMETER deploymentName
    The deployment name.

 .PARAMETER azureDeployAlwaysOn
    Optional, path to the azureDeployAlwaysOn file. Defaults to azureDeployAlwaysOn.json.

 .PARAMETER parametersAlwaysOn
    Optional, path to the parameters file. Defaults to parametersAlwaysOn.json. If file is not found, will prompt for parameter values based on template.

 .PARAMETER azureDeployTestVM
    Optional, path to the azureDeployTestVM file. Defaults to azureDeployTestVM.json.

 .PARAMETER parametersVM
    Optional, path to the parameters file. Defaults to parametersVM.json. If file is not found, will prompt for parameter values based on template.


#>

param(
 [Parameter(Mandatory=$True)]
 [string]
 $subscriptionId,

 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupName,

 [string]
 $resourceGroupLocation,

 [Parameter(Mandatory=$True)]
 [string]
 $deploymentName,

 [string]
 $azureDeployAlwaysOn = (Get-Location).ToString() +  '\azureDeployAlwaysOn.json',

 [string]
 $parametersAlwaysOn = (Get-Location).ToString() +  '\parametersAlwaysOn.json',
 
 [string]
 $azureDeployTestVM = (Get-Location).ToString() +  '\azureDeployTestVM.json',

 [string]
 $parametersVM = (Get-Location).ToString() +  '\parametersAlwaysOn.json'
 
 
)

<#
.SYNOPSIS
    Registers RPs
#>
Function RegisterRP {
    Param(
        [string]$ResourceProviderNamespace
    )

    Write-Host "Registering resource provider '$ResourceProviderNamespace'";
    Register-AzureRmResourceProvider -ProviderNamespace $ResourceProviderNamespace;
}

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

Write-host "This scrip deploys AlwaysOn Availabi SQL Server VM for testing purpouses? (Default is No)" -ForegroundColor Yellow 
    $ReadHost = Read-Host " ( y / n ) " 
	Switch ($ReadHost) 
     { 
       Y {$TestVM=$true} 
       N {$TestVM=$false} 
       Default {$TestVM=$false} 
     } 

# sign in
Write-Host "Logging in...";
Login-AzureRmAccount;

# select subscription
Write-Host "Selecting subscription '$subscriptionId'";
Select-AzureRmSubscription -SubscriptionID $subscriptionId;

# Register RPs
$resourceProviders = @("microsoft.resources");
if($resourceProviders.length) {
    Write-Host "Registering resource providers"
    foreach($resourceProvider in $resourceProviders) {
        RegisterRP($resourceProvider);
    }
}

#Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    Write-Host "Resource group '$resourceGroupName' does not exist. To create a new resource group, please enter a location.";
    if(!$resourceGroupLocation) {
        $resourceGroupLocation = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
}
else{
    Write-Host "Using existing resource group '$resourceGroupName'";
}

# Start Always On Availability Grup deployment
Write-Host "Starting deployment of Always On Availability Grup...";
if(Test-Path $parametersAlwaysOn) {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $azureDeployAlwaysOn -TemplateParameterFile $parametersAlwaysOn;
} else {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $azureDeployAlwaysOn;
}

Write-Host "Deployment of Always On Avilability Group has been succesfully finished";

# Start TEST VM deployment (optional)

if($TestVM) {
Write-Host "Starting deployment of Test VM...";
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $azureDeployTestVM -TemplateParameterFile $parametersVM;
} else {
Write-Host "Starting deployment of Test VM...";
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $azureDeployTestVM;
}