# Deploying Azure Stream Analytics in Terraform using ARM templates to include SQL Reference Data

## :compass: Introduction

In this scenario, we want to create an Azure Stream Analytics job that takes input data from Azure Event Hub and **uses reference data from an Azure SQL Database** - and then outputs the data after transformation into a Service Bus Topic. We want to deploy the resources using [Terraform](https://www.terraform.io/intro/index.html), simply because it is an awesome Infrastructure as Code (IaC) tool that allows you to build, change and version infrastructure.

The challenge with deploying this? As described in [this issue](https://github.com/terraform-providers/terraform-provider-azurerm/issues/9231), the `azurerm` Terraform provider currently does not include support for SQL reference data lookup - it currently only supports Azure blob storage reference data lookup.

But not to worry! There is another way to deploy Azure Stream Analytics including SQL reference data in Terraform: using ARM Template deployments.

## :popcorn: Requirements

Before you get started, make sure the following is in place:

- An Azure subscription ID and tenant ID in which you want the resources to be deployed. You can find this information using the [Azure CLI](https://docs.microsoft.com/cli/azure/manage-azure-subscriptions-azure-cli) or the [Azure Portal](https://docs.microsoft.com/azure/media-services/latest/setup-azure-subscription-how-to?tabs=portal).
- An Azure Service Principal ID and secret corresponding to above tenant ID. You can create this using the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli).
- Add these four secrets to [GitHub Secrets](https://docs.github.com/en/actions/reference/encrypted-secrets), so they can be used as environment variables to authenticate in the [GitHub Actions workflow](./.github/workflows/terraform-github.yml). Make sure to name your secrets as follows:

  - `ARM_SUBSCRIPTION_ID` - The Azure subscription ID in which you want to deploy your resources.
  - `ARM_TENANT_ID` - The Azure tenant ID to where the Azure Service Principal was created.
  - `ARM_CLIENT_ID` - The ID of the created Service Principal.
  - `ARM_CLIENT_SECRET` - The secret of the created Service Principal.

- Terraform needs a place to store its state file. Therefore, add five additional GitHub Secrets that describe the desired resource group name, storage name and container name where the state file will be added, the name of the state file, and the region where you want these state file resources deployed. Please note: these resources don't need to exist yet.

  - `STATE_RG_NAME` - The name of the resource group in which the state file should be added.
  - `STATE_STOR_NAME` - The name of the storage account in which the state file should be added.
  - `CONTAINER_NAME` - The name of the storage container where the state file should be added.
  - `STATE_KEY` - The name of the state file, for example examplestatefile.tfstate.
  - `LOCATION` - The Azure region in which you want above state file resources deployed.

## :factory: How it works

Once you run the [GitHub Actions workflow](./.github/workflows/terraform-github.yml), the following steps kick off.

- Using `state-resources.sh`, the resources to store the Terraform state file are created (or, if they already exist, nothing happens), using the parameters you defined in your GitHub Secrets.

- Terraform sets up, checks the format of your files, initializes and then generates an execution plan. This execution plan (create, update or destroy resources) is based on the resources defined in `main.tf`. In this case, it creates a separate resource group in which the resources are deployed; an Azure Event Hub for potential data input into Azure Stream Analytics; an empty Azure SQL Database for potential reference data to be used by Azure Stream Analytics; a Service Bus Topic for potential data output; and an Azure Stream Analytics Job including necessary blob storage.

- Instead of deploying the [Terraform Azure Stream Analytics Job](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/stream_analytics_job), we deploy a [Terraform Azure Resource Group Template Deployment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) in [main.tf](./main.tf). This deployment template references an [ARM template](./stream-analytics/asa-template.json), which specifies the Azure Stream Analytics instance to be created. The ARM template references the parameters provided in the deployment template - specifically, for our use case, it uses the `referenceQuery` parameter (referring to the SQL reference data lookup query) and defines it as reference data for the Azure Stream Analytics job. **Please remove the comments from the [ARM template](./stream-analytics/asa-template.json), as they result in compiling errors but are included in this repo for explanatory purposes**.

- The plan is then executed upon when there is a push to the `main` branch.

Please note that above set-up does not include any streaming data. The defined Azure Stream Analytics and SQL queries are therefore fictitious.

## :shower: Clean-up

To avoid unnecessary costs, don't forget to destroy the created resources.

## :yellow_heart: Contributing

Not working as expected or nice little additions necessary? PRs are welcome! For major changes, please open an issue first.

## :orange_book: License

[MIT](https://choosealicense.com/licenses/mit/)
