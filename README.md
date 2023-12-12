# Azure Mod for Flowpipe

Azure pipeline library for [Flowpipe](https://flowpipe.io), enabling seamless integration of Azure services into your workflows.

## Documentation

- **[Pipelines →](https://hub.flowpipe.io/mods/turbot/azure/pipelines)**

## Getting Started

### Requirements

Docker daemon must be installed and running. Please see [Install Docker Engine](https://docs.docker.com/engine/install/) for more information.

### Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-mod-azure.git
cd flowpipe-mod-azure
```

### Credentials

By default, the following environment variables will be used for authentication:

- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_TENANT_ID`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/azure.fpc
```

```hcl
credential "azure" "default" {
  client_id     = "<your client id>"
  client_secret = "<your client secret>"
  tenant_id     = "<your tenant id>"
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

### Usage

Build the Docker image:

```sh
docker build -t my-azure-image -f Docker/Dockerfile ./Docker
```

List pipelines:

```sh
flowpipe pipeline list
```

Run a pipeline:

```sh
flowpipe pipeline run list_compute_virtual_machines
```

You can pass in pipeline arguments as well:

```sh
flowpipe pipeline run create_compute_virtual_machine --arg vm_name='VM Dev' --arg vm_image=Ubuntu2204
```

To use a specific `credential`, specify the `cred` pipeline argument:

```sh
flowpipe pipeline run list_compute_virtual_machines --arg cred=azure_prod
```

For more examples on how you can run pipelines, please see [Run Pipelines](https://flowpipe.io/docs/run/pipelines).

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [Azure Mod](https://github.com/turbot/flowpipe-mod-azure/labels/help%20wanted)
