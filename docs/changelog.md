# Changelog

* **20 Feb 2019:**
  * Added the [Building a worker executable](build-process/worker-build-process.md) documentation page.
  * Added the [Building a schema descriptor](build-process/schema-descriptor-build-process.md) documentation page.
  * Added the [Migration guide](migration-guide/migration-guide-master-page.md) documentation page.
  * Added the [Converting project configuration files](migration-guide/configs-conversion-guide.md) documentation page.
* **15 Feb 2019:**
  * `spatial local launch`, `spatial cloud upload` and `spatial cloud launch` no longer work with FPL projects anymore. Please use the respective `alpha` commands (`spatial alpha local launch`, `spatial alpha cloud upload` and `spatial alpha cloud launch`) going forward.
  * Changed the signature of the `spatial alpha cloud upload` and `spatial alpha cloud launch` CLI commands: Replaced all positional arguments with mandatory flags. For more information, please run the commands with the `--help` flag.
  * Removed the `--optimize_for_runtime_v2` CLI flag and added a new `--using_old_loadbalancer` flag for `spatial alpha local launch`. We now optimize for the [new Runtime](https://docs.improbable.io/reference/latest/releases/upgrade-guides/upgrade-runtime) by default. Please set the `--using_old_loadbalancer` flag if you want to start a local deployment with the old Runtime.
  * Merged the content of the world configuration file (`world.json`) into the [launch configuration](reference/launch-configuration.md). We no longer support using the world configuration file. We also removed the `--world` flag from `spatial alpha local launch` and `spatial alpha cloud launch`.
  * Added a `streamingQueryInterval` field to the [launch configuration](reference/launch-configuration.md).
  * Added a `launchConfig` field in the [project configuration](reference/project-configuration.md).
  * Added `loginRateLimit` and `connectionCapacityLimit` fields to the [client-worker configuration](reference/client-worker-configuration.md).
  * Added `launcherCommand` and `launcherArguments` fields to the `uploadConfiguration` section of the [client-worker configuration](reference/client-worker-configuration.md).
* **30 Jan 2019:** 
  * Moved the snapshot file from `./shared`  to `./SpatialOS/snapshots`.
  * Added this changelog.
  * Added a known issues section to the [readme](../README.md#known-issues).
  * Added a [FAQ section](migration-guide/faq.md).
  * Upgraded the deployment launch configuration to use the `small` template.
* **29 Jan 2019:** Upgraded code examples to use `spatial alpha local launch`, `spatial alpha cloud upload` and `spatial alpha cloud launch`.
* **22 Jan 2019:** Upgraded worker SDK version to `13.5.1`.
* **21 Jan 2019:** Added an upload configuration to the client-worker.
