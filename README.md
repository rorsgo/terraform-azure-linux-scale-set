# Linux Scale Set Example

This repository shows how we can use Containers and Terraform to build a Linux VM Scalable Sets. This tutorial uses a cloud storage container to store the Terraform backend. Click [*here*](https://www.terraform.io/docs/language/settings/backends/configuration.html) to see options of how you can manage your Terraform backend.

</br>

## Prerequisites

- You need to have a [Service Principal](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli) - it gives you a `CLIENT_ID` and `CLIENT_PASSWORD` that I am using as environment variables (*example.env*) </br>

- You need an Azure [SUBSCRIPTION_ID](https://docs.microsoft.com/en-us/azure/media-services/latest/how-to-set-azure-subscription?tabs=portal) and [TENANT_ID](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-how-to-find-tenant) to make the communication between Terraform and the provider.</br>

- This tutorial uses a remote Terraform state which requires a [Storage Account](https://docs.microsoft.com/en-us/cli/azure/storage/account?view=azure-cli-latest#az_storage_account_create) and a [Blob container](https://docs.microsoft.com/en-us/cli/azure/storage/container?view=azure-cli-latest#az_storage_container_create). These resources store our Terraform state file. Try it [here](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage). Both resources provide information to connect our backend remotely.</br>
  
    To configure our backend remotely, there are many ways. Here it uses:
  1. the environment variables, such as `ARM_ACCESS_KEY` in **example.env**;
   
  2. the Terraform variables (.tfvars), such as `resource_group_name`, `storage_account_name`, `key`, `container_name` in **example-backend-config.tfvars**. These variables are to read/modify our Terraform state file on Azure.

    The `ARM_ACCESS_KEY` is accessible in the **Access keys** menu on your Azure storage account.

- You need a container engine. This tutorial covers [Podman](https://podman.io/) and [Docker](https://www.docker.com/), that will enable us to run Terraform in it.

If you already have resources in your infrastructure, consider [importing](https://www.terraform.io/docs/cli/import/index.html) them to your state. 

</br>

# Getting Started

### Clone the project
</br>

```
git clone https://github.com/rorvts/terraform-azure-linux-scale-set.git
```

</br>

## Create the Container Environment
### Building a container environment to start the Terraform project

</br>

#### Docker

```
sudo docker run -it -v $PWD:/app -w /app --label terraform --env-file ./example.env --entrypoint "" hashicorp/terraform:light sh
```
If you belong to the [Docker Group](https://docs.docker.com/engine/install/linux-postinstall/), you do not need the statement `sudo`. 

</br>

#### Podman
```
podman run -it -v $PWD:/app -w /app --label terraform --env-file ./example.env --entrypoint "" hashicorp/terraform:light sh
```

</br>

## Configure Terraform in the container

</br>

### Initialize Terraform with your remote state configuration (*example-backend-config.tfvars*)

</br>

```
terraform init --backend-config=./example-backend-config.tfvars
```

</br>

## Generate the Terraform plan

</br>

```
terraform plan -var-file="example-secret.tfvars" -out=plan
```

</br>

## Apply the Terraform plan

</br>

```
terraform apply "plan"
```

</br>

## Destroy the infrastructure created

</br>

```
terraform destroy "plan"
```

**Note: If you had added a resource in your terraform state, it will be on the [destroy](https://www.terraform.io/docs/cli/import/usage.html) command. Take careful!**

</br>

## **Contribute**

- Fork this repository;
- Make a branch with your feature: `git checkout -b my-feature`;
- Commit the changes: `git commit -m 'feat: My new feature'`;
- Push to your branch: `git push origin my-feature`;
- Open a pull request [Pull Request](https://help.github.com/en/enterprise/2.16/user/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork).

</br>

## **Credits**

- Author: Rodrigo Santos [@rorsgo](https://www.linkedin.com/in/rorsgo/)


</br>

## **License**
This repository is under **MIT LICENSE**. For more information, read the [LICENSE](./LICENSE) file.