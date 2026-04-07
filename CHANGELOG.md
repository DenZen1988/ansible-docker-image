# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [3.13.1] - 2026-04-02 (Initial Release)

### Added

* ansible Docker Image based on python3.13:slim with the following collections integrated:
  * ansible.netcommon
  * ansible.posix
  * ansible.utils
  * cisco.nxos
  * community.docker
  * community.general
  * community.grafana
  * community.hashi_vault
  * community.network
  * community.postgresql
  * community.rabbitmq
  * dellemc.openmanage
  * juniper.device
  * kubernetes.core
  * netbox.netbox
* ansible-wrapper script for local usage so the ansible commands can be run the same like on a local installation

[unreleased]: https://github.com/DenZen1988/ansible-docker-image/compare/default...v3.13.1
[3.13.1]: https://github.com/DenZen1988/ansible-docker-image/compare/default...v3.13.1
