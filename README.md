# Axenon DevOps Template for new orgs


## Setup

To setup a repository for a new org with the workflows, one can create a new repo from tempalate and use this one.
After that is done, go to `Settings` and add the Salesforce AuthUrl as `secrets` under the names `SFDX_DEV_URL`, `SFDX_QA_URL` and `SFDX_PROD_URL` with the respective enviroment AuthUrl under each secret. Once that is done the workflows will be able to auth against each environment. To get the secrets:

`sfdx force:org:display -u <ALIAS> --verbose` will generate the Sfdx Auth Url
The URL has format `"force://<clientId>:<clientSecret>:<refreshToken>@<instanceUrl>"`.

If QA is not needed than the QA related jobs can be disabled. Either way the jobs will not be triggered since the
qa branch will not exist.
## WorkFlows

### pr-dev-branch.yml

A workflow that runs when a pull request is opened against the `dev` branch.
Triggers is a pull request is `opened`, `synchronized` or `edited`. This means that if the workflow
fails because of wrong test specified in the pull request template or because code doesn't pass the test
all new commits to the feature-branch will get synchronized to the pull request and the workflow will re-run.

### push-develop-branch.yml

A workflow that runs when a pull request is approved and pushed to `dev` branch.

When a pull request is approved a "change set" is created under the hood, `sfdx sgd:source:delta --to "HEAD" --from "BRANCHING POINT COMMIT SHA"`. This means that the change set contains everything from the recent commit to the previous commit on the branch.

This change set is later on deployed to the sandbox stored as `SFDX_DEV_URL` in a secret. The deployment is done in
below fashion:
`sfdx force:source:deploy -p "changed-sources/force-app" --testlevel RunLocalTests --json`
meaning all test on that enviroment is run and a log is returned when finished. 
This job is assumed to never fail.