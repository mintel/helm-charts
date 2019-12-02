# Mintel Helm repository

Note, this is WIP. Stay tuned!

## Add Mintel repository to Helm repos:

```
helm repo add mintel https://mintel.github.io/helm-charts
```

## Install dex-k8s-authenticator

```
helm upgrade -i dex-k8s-authenticator mintel/dex-k8s-authenticator
```

See [the chart](https://github.com/mintel/dex-k8s-authenticator/tree/master/charts/dex-k8s-authenticator) for more info.
