# Mintel Helm repository

Mintel application Helm Charts for Kubernetes [Helm](https://helm.sh/).

## Usage

### Adding Mintel Charts Repo
```
helm repo add mintel https://mintel.github.io/helm-charts
```

### Searching Mintel Charts
```
helm search repo mintel --devel
```
```
NAME              			CHART VERSION	APP VERSION	DESCRIPTION
mintel/standard-application-stack	0.1.0-rc1    	     		Mintel Standard Application Stack
```

**Note**: At Mintel, we handle consume these using [Tanka](https://tanka.dev/helm) which is our primary means of templating Kubernetes manifests.

### Contributing
Whenever making a change to a chart, you must update the version:
- Update `<chartname>/CHANGELOG.md`
- Update `<chartname>/Chart.yaml` with the new version number from `CHANGELOG.md`
- Run pre-commit hook to automatically update the docs
    ````
    pre-commit install && pre-commit run -a
    ````

### Testing
[Unit tests](https://github.com/quintush/helm-unittest) are integrated into the pull request workflow, but can also be run locally.
```
helm plugin install https://github.com/quintush/helm-unittest
helm unittest -3 ./charts/standard-application-stack
```
