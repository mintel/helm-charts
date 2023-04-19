# terraform-cloud

![Version: 0.38.0](https://img.shields.io/badge/Version-0.38.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.0.0](https://img.shields.io/badge/AppVersion-2.0.0-informational?style=flat-square)

A Helm chart for provisioning resources using Terraform Cloud

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| activeMQ.enabled | bool | `false` | Set to true to create an activeMQ AWS amazonMQ instance |
| activeMQ.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| activeMQ.terraform | object | `{"defaultVars":{},"instances":{},"module":{"source":"app.terraform.io/Mintel/amazonmq/aws","version":"0.0.2"}}` | Set ArgoCD syncWave for this resource (default -40) syncWave: -40 |
| activeMQ.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined below |
| activeMQ.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| activeMQ.terraform.module.source | string | `"app.terraform.io/Mintel/amazonmq/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/amazonmq/aws) |
| activeMQ.terraform.module.version | string | `"0.0.2"` | Module version |
| auroraMySql.enabled | bool | `false` | Set to true to create a MySQL Aurora RDS cluster |
| auroraMySql.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| auroraMySql.terraform.defaultVars | object | See below | Vars to be applied to all instances defined below |
| auroraMySql.terraform.defaultVars.engine | string | `"aurora-mysql"` | Database engine to use (should always be "aurora-mysql") |
| auroraMySql.terraform.defaultVars.engine_version | string | `"5.7.mysql_aurora.2.10.2"` | Aurora MySQL version |
| auroraMySql.terraform.defaultVars.port | int | `3306` | Aurora MySQL port |
| auroraMySql.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| auroraMySql.terraform.module.source | string | `"app.terraform.io/Mintel/rds-aurora/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/rds-aurora/aws) |
| auroraMySql.terraform.module.version | string | `"0.0.3"` | Module version |
| auroraPostgresql.enabled | bool | `false` | Set to true to create a PostgreSQL Aurora RDS cluster |
| auroraPostgresql.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| auroraPostgresql.terraform | object | `{"defaultVars":{"engine":"aurora-postgresql","engine_version":"14.3","instance_class":"db.t3.medium","port":5432},"instances":{},"module":{"source":"app.terraform.io/Mintel/rds-aurora/aws","version":"0.0.3"}}` | Set ArgoCD syncWave for this resource (default -40) syncWave: -40 |
| auroraPostgresql.terraform.defaultVars | object | See below | Vars to be applied to all instances defined below |
| auroraPostgresql.terraform.defaultVars.engine | string | `"aurora-postgresql"` | Database engine to use (should always be "aurora-postgresql") |
| auroraPostgresql.terraform.defaultVars.engine_version | string | `"14.3"` | Aurora PostgreSQL version |
| auroraPostgresql.terraform.defaultVars.instance_class | string | `"db.t3.medium"` | Instance type |
| auroraPostgresql.terraform.defaultVars.port | int | `5432` | Aurora PostgreSQL port |
| auroraPostgresql.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| auroraPostgresql.terraform.module.source | string | `"app.terraform.io/Mintel/rds-aurora/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/rds-aurora/aws) |
| auroraPostgresql.terraform.module.version | string | `"0.0.3"` | Module version |
| dynamodb.enabled | bool | `false` | Set to true to create a DynamoDB instance |
| dynamodb.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| dynamodb.terraform | object | `{"defaultVars":{},"instances":{},"module":{"source":"app.terraform.io/Mintel/dynamodb/aws","version":"1.0.0"}}` | Set ArgoCD syncWave for this resource (default -40) syncWave: -40 |
| dynamodb.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined below |
| dynamodb.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| dynamodb.terraform.module.source | string | `"app.terraform.io/Mintel/dynamodb/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/dynamodb/aws) |
| dynamodb.terraform.module.version | string | `"1.0.0"` | Module version |
| extraIAM.enabled | bool | `false` | Set to true to create an IAM Role or user aside from IRSA for the application |
| extraIAM.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| extraIAM.terraform | object | `{"defaultVars":{},"instances":{},"module":{"source":"app.terraform.io/Mintel/app-iam/aws","version":"2.1.2"}}` | Set ArgoCD syncWave for this resource (default -20) syncWave: -20 |
| extraIAM.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined below |
| extraIAM.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| extraIAM.terraform.module.source | string | `"app.terraform.io/Mintel/app-iam/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/app-iam/aws) |
| extraIAM.terraform.module.version | string | `"2.1.2"` | Module version |
| global.clusterDomain | string | `"127.0.0.1.nip.io"` | Additional labels to apply to all resources |
| global.clusterEnv | string | `"local"` | Environment (local, dev, qa, prod) |
| global.clusterName | string | `""` | Kubernetes cluster name |
| global.clusterRegion | string | `""` | Kubernetes cluster region |
| global.name | string | `"example-app"` | Name of the application |
| global.owner | string | `""` | Team which "owns" the application |
| global.partOf | string | `""` | Top level application each deployment is a part of |
| global.terraform.agentPoolID | string | `""` | ID of the Terraform Cloud Agent Pool to use for the run. Passed in from cluster-env-jsonnet |
| global.terraform.externalSecrets | bool | `true` | Set to true as part of tf cloud migrations. When true, it stops standard-application-stack from creating AWS related external secrets and passes that responsibility to the terraform-cloud chart |
| global.terraform.irsa | bool | `true` | Set to true as part of tf cloud migrations. When true, standard-application-stack sets the service account eks annotation to match the new IAM roles created by the app-iam module |
| global.terraform.organization | string | `"Mintel"` | Name of our Terraform Cloud org |
| global.terraform.secretsMountPath | string | `"/tmp/secrets"` | Where secrets are mounted inside the Terraform Operator container |
| global.terraform.terraformVersion | string | `"1.0.7"` | Global Terraform version for all modules |
| irsa.enabled | bool | `false` | Set to true to explicitly instantiate this module if there's need to access resources created elsewhere |
| irsa.terraform | object | `{"module":{"source":"app.terraform.io/Mintel/app-iam/aws","version":"2.1.2"},"vars":{}}` | Set ArgoCD syncWave for this resource (default -20) syncWave: -20 |
| irsa.terraform.module.source | string | `"app.terraform.io/Mintel/app-iam/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/app-iam/aws) |
| irsa.terraform.module.version | string | `"2.1.2"` | Module version |
| irsa.terraform.vars | object | See below | Vars to be applied to all instances defined below |
| mariadb.enabled | bool | `false` | Set to true to create a MariaDB RDS instance |
| mariadb.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| mariadb.terraform | object | `{"defaultVars":{"engine":"mariadb","engine_version":"10.5","port":3306},"instances":{},"module":{"source":"app.terraform.io/Mintel/rds/aws","version":"1.1.0"}}` | Set ArgoCD syncWave for this resource (default -40) syncWave: -40 |
| mariadb.terraform.defaultVars | object | See below | Vars to be applied to all instances defined below |
| mariadb.terraform.defaultVars.engine | string | `"mariadb"` | Database engine to use (should always be "mariadb") |
| mariadb.terraform.defaultVars.engine_version | string | `"10.5"` | MariaDB version |
| mariadb.terraform.defaultVars.port | int | `3306` | MariaDB port |
| mariadb.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| mariadb.terraform.module.source | string | `"app.terraform.io/Mintel/rds/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/rds/aws) |
| mariadb.terraform.module.version | string | `"1.1.0"` | Module version |
| memcached.enabled | bool | `false` | Set to true to create a memcached Elasticache resource |
| memcached.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| memcached.terraform | object | `{"defaultVars":{"instance_type":"cache.t4g.micro","num_cache_nodes":1},"instances":{},"module":{"source":"app.terraform.io/Mintel/memcached/aws","version":"1.0.1"}}` | Set ArgoCD syncWave for this resource (default -40) syncWave: -40 |
| memcached.terraform.defaultVars | object | See below | Vars to be applied to all instances defined below |
| memcached.terraform.defaultVars.instance_type | string | `"cache.t4g.micro"` | EC2 instance type to use (https://aws.amazon.com/elasticache/pricing) |
| memcached.terraform.defaultVars.num_cache_nodes | int | `1` | Number of nodes to create in the cluster |
| memcached.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| memcached.terraform.module.source | string | `"app.terraform.io/Mintel/memcached/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/memcached/aws) |
| memcached.terraform.module.version | string | `"1.0.1"` | Module version |
| opensearch.enabled | bool | `false` | Set to true to create an Opensearch cluster |
| opensearch.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| opensearch.terraform | object | `{"defaultVars":null,"instances":{},"module":{"source":"app.terraform.io/Mintel/opensearch/aws","version":"1.2.1"}}` | Set ArgoCD syncWave for this resource (default -40) syncWave: -40 |
| opensearch.terraform.defaultVars | string | `nil` | Vars to be applied to all instances defined below |
| opensearch.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| opensearch.terraform.module.source | string | `"app.terraform.io/Mintel/opensearch/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/opensearch/aws) |
| opensearch.terraform.module.version | string | `"1.2.1"` | Module version |
| postgresql.enabled | bool | `false` | Set to true to create a PostgreSQL RDS instance |
| postgresql.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| postgresql.terraform.defaultVars | object | See below | Vars to be applied to all instances defined below |
| postgresql.terraform.defaultVars.engine | string | `"postgres"` | Database engine to use (should always be "postgres") |
| postgresql.terraform.defaultVars.engine_version | string | `"13"` | PostgreSQL version |
| postgresql.terraform.defaultVars.port | int | `5432` | PostgreSQL port |
| postgresql.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| postgresql.terraform.module.source | string | `"app.terraform.io/Mintel/rds/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/rds/aws) |
| postgresql.terraform.module.version | string | `"1.1.0"` | Module version |
| redis.enabled | bool | `false` | Set to true to create a Redis Elasticache resource |
| redis.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| redis.terraform | object | `{"defaultVars":{},"instances":{},"module":{"source":"app.terraform.io/Mintel/redis/aws","version":"1.1.0"}}` | Set ArgoCD syncWave for this resource (default -40) syncWave: -40 |
| redis.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined below |
| redis.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| redis.terraform.module.source | string | `"app.terraform.io/Mintel/redis/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/redis/aws) |
| redis.terraform.module.version | string | `"1.1.0"` | Module version |
| s3.enabled | bool | `false` | Set to true to create an S3 bucket |
| s3.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| s3.terraform | object | `{"defaultVars":{},"instances":{},"module":{"source":"app.terraform.io/Mintel/private-s3-bucket/aws","version":"1.3.3"}}` | Set ArgoCD syncWave for this resource (default -40) syncWave: -40 |
| s3.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined below |
| s3.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| s3.terraform.module.source | string | `"app.terraform.io/Mintel/private-s3-bucket/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/private-s3-bucket/aws) |
| s3.terraform.module.version | string | `"1.3.3"` | Module version |
| sns.enabled | bool | `false` | Set to true to create an SNS resource |
| sns.eventBus | object | `{"enabled":false}` | Set to true to add the MintelEventBus tag |
| sns.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| sns.terraform | object | `{"defaultVars":{},"instances":{},"module":{"source":"app.terraform.io/Mintel/sns/aws","version":"1.0.0"}}` | Set ArgoCD syncWave for this resource (default -40) syncWave: -40 |
| sns.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined below |
| sns.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| sns.terraform.module.source | string | `"app.terraform.io/Mintel/sns/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/sns/aws) |
| sns.terraform.module.version | string | `"1.0.0"` | Module version |
| sqs.enabled | bool | `false` | Set to true to create an SQS resource |
| sqs.eventBus | object | `{"enabled":false}` | Set to true to add the MintelEventBus tag |
| sqs.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| sqs.terraform | object | `{"defaultVars":{},"instances":{},"module":{"source":"app.terraform.io/Mintel/sqs/aws","version":"1.1.0"}}` | Set ArgoCD syncWave for this resource (default -40) syncWave: -40 |
| sqs.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined below |
| sqs.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| sqs.terraform.module.source | string | `"app.terraform.io/Mintel/sqs/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/sqs/aws) |
| sqs.terraform.module.version | string | `"1.1.0"` | Module version |
| sshKeyPairSecret.enabled | bool | `false` | Set to true to create AWS secret manager secrets for an SSH key pair |
| sshKeyPairSecret.terraform | object | `{"defaultVars":{},"instances":{},"module":{"source":"app.terraform.io/Mintel/ssh-keypair-secret/aws","version":"0.0.5"}}` | Set ArgoCD syncWave for this resource (default -40) syncWave: -40 |
| sshKeyPairSecret.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined below |
| sshKeyPairSecret.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| sshKeyPairSecret.terraform.module.source | string | `"app.terraform.io/Mintel/ssh-keypair-secret/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/ssh-keypair-secret/aws) |
| sshKeyPairSecret.terraform.module.version | string | `"0.0.5"` | Module version |
| staticWebsite.enabled | bool | `false` | Set to true to create static website (a public bucket and associated resources) |
| staticWebsite.outputSecret | bool | `true` | Set to true to create an AWS secret manager external secret with outputs |
| staticWebsite.terraform | object | `{"defaultVars":{},"instances":{},"module":{"source":"app.terraform.io/Mintel/public-static-website/aws","version":"1.1.0"}}` | Set ArgoCD syncWave for this resource (default -40) syncWave: -40 |
| staticWebsite.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined below |
| staticWebsite.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| staticWebsite.terraform.module.source | string | `"app.terraform.io/Mintel/public-static-website/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/public-static-website/aws) |
| staticWebsite.terraform.module.version | string | `"1.1.0"` | Module version |
| stepFunctionEks.enabled | bool | `false` | Set to true to create an EKS runtime step function |
| stepFunctionEks.outputSecret | bool | `false` | Set to true to create an AWS secret manager external secret with outputs |
| stepFunctionEks.terraform.defaultVars | object | `{}` | Vars to be applied to all instances defined below |
| stepFunctionEks.terraform.instances | object | `{}` | A map of instance names => variable key/value pairs to be sent to the terraform module. The values in `defaultVars` will be applied to every instance if not explicitly defined here. |
| stepFunctionEks.terraform.module.source | string | `"app.terraform.io/Mintel/step-functions-eks/aws"` | Registry path of the Terraform module used to create the resource (https://app.terraform.io/app/Mintel/registry/modules/private/Mintel/step-function-eks/aws) |
| stepFunctionEks.terraform.module.version | string | `"1.0.0"` | Module version |
| stepFunctionEks.terraform.terraformVersion | string | `"1.3.0-alpha20220608"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)
