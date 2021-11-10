# Change Log

This file documents all notable changes to the Mintel standard-application-stack Helm Chart. The release
numbering uses [semantic versioning](http://semver.org).

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
