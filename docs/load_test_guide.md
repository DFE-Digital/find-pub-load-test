## Intro
This document contains the setup Find load test. It piggybacks off the existing load testing work shown in the repo's main README.

## Setup

The setup for the load test involves the following steps:
1. Writing a test plan
2. Creating and uploading a docker image for the test run
3. Deploying the load test app to PaaS

### Writing a test plan
The test plan for the load test can be found at `plans/find.rb`. This sets out the config for the test, including how long the test runs for and which urls are accessed.

The tests are written using the `ruby-jmeter` gem, which is documented here https://github.com/flood-io/ruby-jmeter.

### Creating and uploading a docker image for the test run
You'll need docker to be installed and running. To build the image, run `$ make build`. However, this only builds the image locally - for the load test, you'll need to push the image up to ghcr.io.

You'll first need to log in to Github with docker, using a [Github PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).
```sh
$ docker login -u [Github Username] -p [Github PAT] ghcr.io
```

Once you're logged in you can run `$ make push` to create and upload the docker image.

### Deploying the load test app to PaaS
The final setup step requires the load testing app to be uploaded to PaaS. You'll need to log into Cloudfront, and ensure that you have the SpaceDeveloper role. You'll also need to be able to get [one-time passcodes from PaaS](https://login.london.cloud.service.gov.uk/passcode)

You can run `$ make find deploy-plan PASSCODE=[PaaS passcode]` to see the deploy plan, and you can run the command below to deploy it. This will also start the `find-jmeter` load testing app.

```shell
$ make find deploy PASSCODE=[PaaS passcode]
```

## Testing
With the load test app deployed, you can view it on PaaS with `$ cf app find-jmeter`. This will show its current status.

To start the load test, run `$ cf start find-jmeter`. This will start running the test plan that you've containerised from `plans/find.rb`.

You can view the logs from the load test app with `$ cf logs --recent find-jmeter` which will show the ongoing test outputs.

To stop the load test app, run `$ cf stop find-jmeter`.

### Grafana
There are a set of dashboards which can be used to view the test while running. Make sure to adjust the time window to match the test timing.

* [`find-jmeter` load testing dashboard](https://grafana-bat.london.cloudapps.digital/d/g7FHKhz7z/load-testing-monitor?orgId=1&from=now-15m&to=now&refresh=5s&var-app=find-loadtest&var-db_service=apply-postgres-loadtest)
* [`find-loadtest` application dashboard](https://grafana-bat.london.cloudapps.digital/d/eF19g4RZx/cf-apps?orgId=1&var-SpaceName=bat-prod&var-Applications=find-loadtest&from=now-15m&to=now&refresh=10s)
* [`publish-teacher-training-loadtest` application dashboard](https://grafana-bat.london.cloudapps.digital/d/eF19g4RZx/cf-apps?orgId=1&var-SpaceName=bat-prod&var-Applications=publish-teacher-training-loadtest&from=now-15m&to=now&refresh=10s)

### Kibana
Logging is turned off normally for the load test environments, as a test will generate a large amount of logs in a short space of time. However, it can be turned on for more detailed information about the server if needed. 

To enable logging, you will need to switch the `paas_enable_external_logging` flag to `true` in the Publish or Find application `terraform/workspace_variables/loadtest.tfvars.json`, and deploy it.

With logging enabled, you can view logs from the loadtest by scoping `cf.app` to the desired app.

There is a saved Kibana search for `Find load test app crashes` which looks for "CRASHED" logs.