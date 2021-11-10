# Mintel Helm repository

Mintel application Helm Charts for Kubernetes [Helm](https://helm.sh/).

## Usage

### Adding Mintel Charts Repo
```
helm repo add mintel https://mintel.github.io/helm-charts
```

### Searchi Mintel Charts
```
helm search repo mintel --devel
```
```
NAME              			CHART VERSION	APP VERSION	DESCRIPTION
mintel/standard-application-stack	0.1.0-rc1    	     		Mintel Standard Application Stack
```

**Note**: At Mintel, we handle consume these using [Tanka](https://tanka.dev/helm) which is our primary means of templating Kubernetes manifests.
