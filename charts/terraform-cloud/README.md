# terraform-cloud

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.0](https://img.shields.io/badge/AppVersion-1.1.0-informational?style=flat-square)

A Helm chart for provisioning resources using Terraform Cloud

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| dynamodb.enabled | bool | `false` | Set to true to create a DynamoDB instance |
| dynamodb.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined |
| dynamodb.terraform.module.source | string | `"app.terraform.io/Mintel/dynamodb/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/dynamodb/aws) |
| dynamodb.terraform.module.version | string | `"0.1.0-beta.1"` | Module version |
| global | object | `{"additionalLabels":{},"cloudProvider":{"accountId":""},"clusterDomain":"127.0.0.1.nip.io","clusterEnv":"local","clusterName":"","clusterRegion":"","ingressTLSSecrets":{},"name":"example-app","owner":"","partOf":"","runtimeEnvironment":"kubernetes","terraform":{"externalSecrets":false,"organization":"Mintel","secretsMountPath":"/tmp/secrets","terraformVersion":"1.0.7"}}` | Global variables for us in all charts and sub charts |
| global.additionalLabels | object | `{}` | Additional labels to apply to all resources |
| global.cloudProvider | object | `{"accountId":""}` | Global variables relating to cloud provider |
| global.cloudProvider.accountId | string | `""` | AWS account ID |
| global.clusterDomain | string | `"127.0.0.1.nip.io"` | Kubernetes cluster domain |
| global.clusterEnv | string | `"local"` | Environment (local, dev, qa, prod) |
| global.clusterName | string | `""` | Kubernetes cluster name |
| global.clusterRegion | string | `""` | Kubernetes cluster region |
| global.ingressTLSSecrets | object | `{}` | Global dictionary of TLS secrets |
| global.name | string | `"example-app"` | Name of the application |
| global.owner | string | `""` | Team which "owns" the application |
| global.partOf | string | `""` | Top level application each deployment is a part of |
| global.runtimeEnvironment | string | `"kubernetes"` | Global variable definint RUNTIME_ENVIRONMENT |
| mariadb.enabled | bool | `false` |  |
| mariadb.terraform.defaultVars | object | `{"engine":"mariadb","engine_version":"10.5","port":3306}` | Vars to be applied to all instances defined |
| mariadb.terraform.module.source | string | `"app.terraform.io/Mintel/rds/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/rds/aws) |
| mariadb.terraform.module.version | string | `"0.1.0-beta.2"` | Module version |
| memcached.enabled | bool | `false` |  |
| memcached.terraform.defaultVars | object | `{"instance_type":"cache.t4g.micro","num_cache_nodes":1}` | Vars to be applied to all instances defined |
| memcached.terraform.module.source | string | `"app.terraform.io/Mintel/memcached/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/memcached/aws) |
| memcached.terraform.module.version | string | `"0.1.0-beta.2"` | Module version |
| opensearch.enabled | bool | `false` |  |
| opensearch.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined |
| opensearch.terraform.module.source | string | `"app.terraform.io/Mintel/opensearch/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/opensearch/aws) |
| opensearch.terraform.module.version | string | `"0.1.0-beta.2"` | Module version |
| postgresql.enabled | bool | `false` |  |
| postgresql.terraform.defaultVars | object | `{"engine":"postgres","engine_version":"13","port":5432}` | Vars to be applied to all instances defined |
| postgresql.terraform.module.source | string | `"app.terraform.io/Mintel/rds/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/rds/aws) |
| postgresql.terraform.module.version | string | `"0.1.0-beta.2"` | Module version |
| redis.enabled | bool | `false` |  |
| redis.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined |
| redis.terraform.module.source | string | `"app.terraform.io/Mintel/redis/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/redis/aws) |
| redis.terraform.module.version | string | `"0.1.0-beta.2"` | Module version |
| s3.enabled | bool | `false` |  |
| s3.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined |
| s3.terraform.module.source | string | `"app.terraform.io/Mintel/private-s3-bucket/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/private-s3-bucket/aws) |
| s3.terraform.module.version | string | `"0.1.0-beta.1"` | Module version |
| sns.enabled | bool | `false` |  |
| sns.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined |
| sns.terraform.module.source | string | `"app.terraform.io/Mintel/sns/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/sns/aws) |
| sns.terraform.module.version | string | `"0.1.0-beta.1"` | Module version |
| sqs.enabled | bool | `false` |  |
| sqs.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined |
| sqs.terraform.module.source | string | `"app.terraform.io/Mintel/sqs/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/sqs/aws) |
| sqs.terraform.module.version | string | `"0.1.0-beta.1"` | Module version |
| staticWebsite.enabled | bool | `false` |  |
| staticWebsite.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined |
| staticWebsite.terraform.module.source | string | `"app.terraform.io/Mintel/public-static-website/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/public-static-website/aws) |
| staticWebsite.terraform.module.version | string | `"0.1.0-beta.1"` | Module version |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)
