 Create New ServiceNow Incident
# John O'Brien
# 1-Sept-2020
# Ver 1.0
# Script will create a new ServiceNow Change via Powershell
 
 
# Eg. User name="admin", Password="admin" for this code sample.
$user = "admin"
$cred = Get-Credential $user
#$pass = "******"
 
# Ensures that Invoke-WebRequest uses TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
 
# Build auth header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$cred.GetNetworkCredential().password)))
 
# Set proper headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','application/json')
$headers.Add('Content-Type','application/json')
 
# Specify endpoint uri
$uri = "https://dev91528.service-now.com/api/now/table/change_request"
 
# Specify HTTP method
$method = "post"
 
 
# Specify request body
$body = "{`"short_description`":`"Testing RESTAPI Explorer directly from POWERSHELL - Change Request`",`"description`":`"Longer version - POWERSHELL Testing RESTAPI Explorer - Change Reqeust`",`"priority`":`"1`",`"category`":`"Hardware`",`"configuration item`":`"*ANNIE-IBM`"}"
 
#ALTERNATIVE METHOD VIA JSON
####$body = get-content -path "h:\file_containing_fields_to_be_created.json" | ConvertFrom-json
 
#ALTERNATIVE METHOD VIA CSV
####$body = get-content -path "h:\csv_file_containing_fields_to_be_created.csv"
 
# Send HTTP request
$response = Invoke-RestMethod -Headers $headers -Method $method -Uri $uri -Body $body
 
# Print response
$response.RawContent
 
 
$changenumber = $response.result.number
 
 
###############################################
# Verifying Incident created and show ID
###############################################
IF ($changenumber -ne $null)
{
"Created Change With ID:$changenumber"
}
ELSE
{
"Change Not Created"
}
##############################################
# End of script
##############################################
