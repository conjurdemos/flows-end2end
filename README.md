# End-to-End Provisioning/Deprovisioning Flows for CyberArk Privilege Cloud and Conjur Cloud

NOTE: The admin user that executes REST calls to Privilege Cloud and Conjur Cloud has full admin rights in both solutions. Its password can be viewed as plaintext in  execution logs for these Flows. There is currently no way to mask or otherwise obfuscate that value. Please be advised and take appropriate caution in granting access to your Flows tenant.

## cd into Setup directory:
- Convert flows for your tenant(s)
  - Edit the convert-flows-for-tenant.sh script
  - Set hostname parameters for tenants appropriately
  - Run script - converted output will be in flows-for-importing/ directory
- Import all three converted flows into Flows tenant
- In each Flow's runtime settings, check 'Anonymous' under 'API access' and Save
- For both the End2End Flows:
  - Click the second connector and use its map to access the Webhook body.
  - Cut/paste the contents of webhook-schemas/end2end-webhook-schema.json as the body of the webhook input parameters and save.
- For the GetAuthTokens-SaaS Flow:
  - Click the second connector and use its map to access the Webhook body.
  - Cut/paste the contents of webhook-schemas/getauthtokens-webhook-schema.json as the body of the webhook input parameters and save.
- Add policy templates to data store for Flows in Flows tenant:
  - Create keys with same names as policy filenames.
  - Paste the file contents directly as values.
- Edit demo.sh:
  - Set appropriate Oauth2 confidential client Admin user and password.
  - Set FLOWS_TENANT to tenant hosting flows.
  - Set REQUESTOR to email address to send confirmation emails.
  - Edit other values as desired. 
- Run 'demo.sh p' to provision, verify Safe, AppID, Conjur workloads, etc.
- Run 'demo.sh d' to deprovision, verify provisioned resources no longer exist.
 
## End2End-Provision Flow details:
Provisions a Safe, an SSH Account, a Vault AppID and Conjur workload with access to the Safe's accounts.
Key parameters are passed in to the webhook entrypoint.

### Provisioning flow steps:
- base64 decodes SSH key passed to webhook
- calls GetAuthnTokens-SaaS to get Vault and Conjur access tokens
- Creates Safe
- Adds Conjur Sync user as member of Safe
- Creates AppID user
- Adds AppID user as member of Safe
- Adds SSH key account to Safe
- creates Conjur workload identity w/ API authn - same name as AppID
- loads delegation/consumers policy for Safe (avoids waiting for sync)
- grants delegation/consumers Role to workload identity
- sends confirmation email

## End2End-Deprovision Flow details:
Performs the inverse of the End2End provisioning flow.
Webhook parameters are same as for the Provisioning workflow.

### Deprovisioning flow steps:
- calls GetAuthnTokens-SaaS to get Vault and Conjur access tokens
- deletes Conjur delegation/consumers policy and admin group
   for Safe (which also deletes all synced secrets)
- deletes Conjur host identity
- deletes AppID user
- deletes Safe
- sends confirmation email
