# SQL Server Availability Group in Azure Virtual Machines

#### Getting Started
Solution based on Azure Quick Start Templates. Script deploys and configures AOAG. Optionally, one Virtual Machine for testing purposes can be deployed in sqlSubnet. The main aim is to connect to the AOAG Listener and perform manual failover. 
The diagram illustrates the parts of a complete SQL Server Availability Group in Azure Virtual Machines.

![](https://github.com/vmaaik/azure-demo/blob/master/diagram/DemoDiagram1.png?raw=true)

####  Running the script

```
./deploy.ps1 -subscriptionId '<azureSubscriptionID>' -resourceGroupName '<resourceGroupName>' -resourceGroupLocation '<resourceGroupLocation>' -deploymentName '<deploymentName>' 
```