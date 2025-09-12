## 2. Let's go

🌞 **Compléter votre plan Terraform pour déployer du Blob Storage pour votre VM**

📁 **Fichiers attendus**

- `main.tf`
- `storage.tf`
- tout autre fichier Terraform utilisé

## 3. Proooooooofs

🌞 **Prouvez que tout est bien configuré, depuis la VM Azure**

```bash
antnaTerraform@cliTerraform:~$ azcopy login --identity
INFO: Login with identity succeeded.
antnaTerraform@cliTerraform:~$  azcopy copy "test.txt" "https://terrestock.blob.core.windows.net/terreblob"
INFO: Scanning...
INFO: Autologin not specified.
INFO: Authenticating to destination using Azure AD
INFO: Any empty folders will not be processed, because source and/or destination doesn't have full folder support

Job 875bf695-bb00-6b48-6cac-eb8e11ae8d40 has started
Log file is located at: /home/antnaTerraform/.azcopy/875bf695-bb00-6b48-6cac-eb8e11ae8d40.log

100.0 %, 1 Done, 0 Failed, 0 Pending, 0 Skipped, 1 Total, 2-sec Throughput (Mb/s): 0.0002


Job 875bf695-bb00-6b48-6cac-eb8e11ae8d40 summary
Elapsed Time (Minutes): 0.0335
Number of File Transfers: 1
Number of Folder Property Transfers: 0
Number of Symlink Transfers: 0
Total Number of Transfers: 1
Number of File Transfers Completed: 1
Number of Folder Transfers Completed: 0
Number of File Transfers Failed: 0
Number of Folder Transfers Failed: 0
Number of File Transfers Skipped: 0
Number of Folder Transfers Skipped: 0
Number of Symbolic Links Skipped: 0
Number of Hardlinks Converted: 0
Number of Special Files Skipped: 0
Total Number of Bytes Transferred: 42
Final Job Status: Completed
antnaTerraform@cliTerraform:~$ azcopy list "https://terrestock.blob.core.windows.net/terreblob"
INFO: Autologin not specified.
INFO: Authenticating to source using Azure AD
test.txt; Content Length: 42.00 B
```

🌞 **Déterminez comment `azcopy login --identity` vous a authentifié**

`azcopy login --identity` = demande un JWT via l’identité managée de la VM → AzCopy s’authentifie auprès de Azure Storage avec ce token.

🌞 **Requêtez un JWT d'authentification auprès du service que vous venez d'identifier, manuellement**

```bash
antnaTerraform@cliTerraform:~$ curl -H "Metadata:true" "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2021-02-01&resource=https://storage.azure.com/"
```

```json
{
    "access_token":"eyJ0eXAiOiJKV1QiLXQpmVIT5DXJiQK2kllRCUpIB14acwPFYi9q5qOLayVcNsPiU-_gQrwRDvDX3ED1KZDP-kA",
    "client_id":"6efac642-778b-45f2-9024-18aad5b7a673",
    "expires_in":"86400",
    "expires_on":"1757774022",
    "ext_expires_in":"86399",
    "not_before":"1757687322",
    "resource":"https://storage.azure.com/",
    "token_type":"Bearer"
}
```

🌞 **Expliquez comment l'IP `169.254.169.254` peut être joignable**

169.254.169.254 est une IP link-local ; la table de routage de la VM envoie tout le trafic vers cette plage directement sur l’interface locale, ce qui permet d’atteindre le service IMDS sans passer par Internet.

```bash
antnaTerraform@cliTerraform:~$ ip route
default via 10.0.1.1 dev eth0 proto dhcp src 10.0.1.4 metric 100
10.0.1.0/24 dev eth0 proto kernel scope link src 10.0.1.4 metric 100
168.63.129.16 via 10.0.1.1 dev eth0 proto dhcp src 10.0.1.4 metric 100
169.254.169.254 via 10.0.1.1 dev eth0 proto dhcp src 10.0.1.4 metric 100
```
