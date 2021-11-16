# Change Log

This file documents all notable changes to the Mintel standard-application-stack Helm Chart. The release
numbering uses [semantic versioning](http://semver.org).

## v0.1.0-rc10

* Fix topologyConstraints to topologySpreadConstraints

## v0.1.0-rc9

* Fixing typo

## v0.1.0-rc8

* Add support for topologyConstraints (zone and node) on deployment and deployment-celery

## v0.1.0-rc7

* Fixing REDIS_PRIMARY_ENDPOINT for celery-exporter and local dev

## v0.1.0-rc6

* Fixing typo's in pod/service monitors
* Adding securityContext for celery-exporter
* Fixing registry logic for image helper

## v0.1.0-rc5

* Fixing KUBERNETES_POD_NAMSPACE env var

## v0.1.0-rc4

* Fix mariadb external secret

## v0.1.0-rc3

* Version bump to test CI

## v0.1.0-rc2

### Minor changes

* Fixing mariadb external secret to transpose the secret keys to the correct environment variables

## v0.1.0-rc1

### Minor changes

* Add missing image tags
* Fix service monitor target labels
* Fix typo relabellings->relabelings in service monitors
* Set default image tag to 'auto-replaced'
