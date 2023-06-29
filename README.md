# Mintel Helm repository

Mintel application Helm Charts for Kubernetes [Helm](https://helm.sh/).

## Usage

### Adding Mintel Charts Repo

```sh
helm repo add mintel https://mintel.github.io/helm-charts
```

### Searching Mintel Charts

```sh
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

[Unit tests](https://github.com/helm-unittest/helm-unittest) are integrated into the pull request workflow, but can also be run locally.

```sh
# Remove old versions of the plugin
helm plugin uninstall unittest

helm plugin install https://github.com/helm-unittest/helm-unittest.git
helm unittest ./charts/standard-application-stack --strict
```

This repo makes use of [snapshot testing](https://github.com/helm-unittest/helm-unittest#snapshot-testing)
to detect unexpected changes to manifests. When you run the tests after making a change that effects existing manifests,
you will see a lot of test errors complaining about differences between what the chart renders and the snapshots.
Review the changes and, if you're satisfied, update the snapshots by rerunning the tests with the `--update-snapshot` flag:

```sh
helm unittest ./charts/standard-application-stack --strict --update-snapshot
```

When adding new tests, please be sure to always add a `matchSnapshot` assertion:

```yaml
- it: does something
  asserts:
    - matchSnapshot: {} # <-- Make sure to always add this after `asserts`!
```
