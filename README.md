# Customer0 PCF+GCP Concourse Pipeline


### Pre_Reqs & Instructions for POC Deployment via Concourse

1. Create a Service Account with "Editor" Role on the target GCP Project
  - Non POC versions of the pipeline will support sep Terraform & Opsman Service accounts
  - ENABLE your GCP Compute API [here](https://console.cloud.google.com/apis/api/compute_component)
  - ENABLE your GCP Storage API [here](https://console.cloud.google.com/apis/api/storage_component)
  - ENABLE your GCP SQL API [here](https://console.cloud.google.com/apis/api/sql_component)
  - ENABLE your GCP DNS API [here](https://console.cloud.google.com/apis/api/dns)
  - ENABLE your GCP Cloud Resource Manager API [here](https://console.cloud.google.com/apis/api/cloudresourcemanager.googleapis.com/overview)
  - ENABLE & Create GCP Storage Interoperability Tokens here [here](https://console.cloud.google.com/storage/settings)
2. Create a Concourse instance with public access for downloads.  Look [here](http://concourse.ci/vagrant.html) for `vagrant` instructions if an ephemeral concourse instance is desired.


3. `git clone` this repo
4. **EDIT!!!** `ci/c0-gcp-concourse-poc-params.yml` and replace all variables/parameters you will want for your concourse individual pipeline run

   - The sample pipeline params file includes 2 params that set the major/minor versions of OpsMan & ERT that will be pulled.  They will typically default to the latest RC/GA avail tiles.
     ```
     opsman_major_minor_version: '1\.9\..*'
     ert_major_minor_version: '1\.9\..*'
     ```
5. **AFTER!!!** Completing Step 4 above ... log into concourse & create the pipeline.

  _(this command syntax assumes you are at the root of your repo)_
  - `fly -t [YOUR CONCOURSE TARGET] set-pipeline -p c0-gcp-concourse-base -c ci/c0-gcp-concourse-poc.yml -l ci/c0-gcp-concourse-poc-params.yml`

6. Un-pause the pipeline
7. Run the **`init-env`** job manually,  you will need to review the output and record it for the DNS records that must then be made resolvable **BEFORE!!!** continuing to the next step:
  - Example:

```
==============================================================================================
This gcp_pcf_terraform_template has an 'Init' set of terraform that has pre-created IPs...
==============================================================================================
Activated service account credentials for: [c0-concourse@pcf-demos.google.com.iam.gserviceaccount.com]
Updated property [core/project].
Updated property [compute/region].
You have now deployed Public IPs to GCP that must be resolvable to:
----------------------------------------------------------------------------------------------
*.sys.gcp-poc.customer0.net == 130.211.9.202
*.cfapps.gcp-poc.customer0.net == 130.211.9.202
ssh.sys.gcp-poc.customer0.net == 146.148.58.174
doppler.sys.gcp-poc.customer0.net == 146.148.58.174
loggregator.sys.gcp-poc.customer0.net == 146.148.58.174
tcp.gcp-poc.customer0.net == 104.198.241.71
opsman.gcp-poc.customer0.net == 104.154.98.48
----------------------------------------------------------------------------------------------
```

**[DEPLOY]**. **AFTER!!!** Completing Step 7 above ... Run the **`deploy-iaas`** job manually, if valid values were passed, a successful ERT deployment on GCP will be the result.

####
Added Stop and Start Scripts
