## 2. Une alerte CPU

🌞 **Compléter votre plan Terraform et mettez en place une alerte CPU**

-> [fichier monitoring](../Terraform/monitoring.tf)

📁 **Fichiers attendus**

- `main.tf`
- `monitoring.tf` (je vous file un exemple en dessous)
- tout autre fichier Terraform utilisé

## 3. Alerte mémoire

🌞 **Compléter votre plan Terraform et mettez en place une alerte mémoire**

-> [fichier monitoring](../Terraform/monitoring.tf)

📁 **Fichiers attendus**

- `main.tf`
- `monitoring.tf`
- tout autre fichier Terraform utilisé

## 4. Proofs

### A. Voir les alertes avec `az`

🌞 **Une commande `az` qui permet de lister les alertes actuellement configurées**

```bash
az monitor metrics alert list --resource-group tp1leoTerraform --output table
AutoMitigate    Description                                       Enabled    EvaluationFrequency    Location    Name                       ResourceGroup    Severity    TargetResourceRegion    TargetResourceType    WindowSize
--------------  ------------------------------------------------  ---------  ---------------------  ----------  -------------------------  ---------------  ----------  ----------------------  --------------------  ------------
True            Alert when CPU usage exceeds 70%                  True       PT1M                   global      cpu-alert-cliTerraform     tp1leoTerraform  2                                                         PT5M
True            Alert when available memory is less than 512 MiB  True       PT1M                   global      memory-alert-cliTerraform  tp1leoTerraform  2                                                         PT5M
```

### B. Stress pour *fire* les alertes

🌞 **Stress de la machine**

```bash
antnaTerraform@cliTerraform:~$ stress-ng --cpu 2 --timeout 60s
stress-ng: info:  [5003] dispatching hogs: 2 cpu
stress-ng: info:  [5003] successful run completed in 60.02s (1 min, 0.02 secs)
antnaTerraform@cliTerraform:~$ stress-ng --vm 1 --vm-bytes 512M --timeout 60s
stress-ng: info:  [5112] dispatching hogs: 1 vm
stress-ng: error: [5114] stress-ng-vm: gave up trying to mmap, no available memory
stress-ng: info:  [5112] successful run completed in 10.01s
```

🌞 **Vérifier que des alertes ont été *fired***

```bash
$ az rest --method get --uri "https://management.azure.com/subscriptions/142f****************************cff2ec6610/providers/Microsoft.AlertsManagement/alerts?api-version=2019-03-01&%24filter=monitorCondition%20eq%20'Fired'"
{
  "value": [
    {
      "id": "/subscriptions/142f****************************cff2ec6610/resourcegroups/tp1leoterraform/providers/microsoft.compute/virtualmachines/cliterraform/providers/Microsoft.AlertsManagement/alerts/33e50ff****************************e3e75df000",
      "name": "memory-alert-cliTerraform",
      "properties": {
        "essentials": {
          "actionStatus": {
            "isSuppressed": false
          },
          "alertRule": "/subscriptions/142f****************************cff2ec6610/resourceGroups/tp1leoTerraform/providers/Microsoft.Insights/metricAlerts/memory-alert-cliTerraform",
          "alertState": "New",
          "description": "Alert when available memory is less than 512 MiB",
          "lastModifiedDateTime": "2025-09-12T15:09:39.9747845Z",
          "lastModifiedUserName": "System",
          "monitorCondition": "Fired",
          "monitorService": "Platform",
          "severity": "Sev2",
          "signalType": "Metric",
          "sourceCreatedId": "142f****************************cff2ec6610_tp1leoTerraform_Microsoft.Insights_metricAlerts_memory-alert-cliTerraform_1011353675",
          "startDateTime": "2025-09-12T15:09:39.9747845Z",
          "targetResource": "/subscriptions/142f****************************cff2ec6610/resourcegroups/tp1leoterraform/providers/microsoft.compute/virtualmachines/cliterraform",
          "targetResourceGroup": "tp1leoterraform",
          "targetResourceName": "cliterraform",
          "targetResourceType": "microsoft.compute/virtualmachines"
        }
      },
      "type": "microsoft.alertsmanagement/alerts"
    }
  ]
}
```

