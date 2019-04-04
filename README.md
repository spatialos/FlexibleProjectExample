# Example project using the [flexible project layout (FPL)](https://docs.improbable.io/reference/latest/shared/flexible-project-layout/introduction)

> **Warning**: The flexible project layout is in [beta maturity](https://docs.improbable.io/reference/latest/shared/release-policy#maturity-stages). It is available for testing and early evaluation but not recommended for public releases. Config files and worker directories are not laid out as best practice or as an example of good project layout - instead, they're laid out to demonstrate the flexibility now available.

## What is it?
This is a simple SpatialOS project with two C# server workers (`HelloWorker` and `DiceWorker`) and one C# client worker (`Client`).

It doesn't require any specific locations for the SpatialOS files - you can put them anywhere in the project as long as you reference them in the `spatialos.json` file.

> **Note**: SpatialOS expects the workers to be pre-built, and only contains information on how to run them. This means the `spatial worker build` command is unavailable - you're responsible for building your workers (see [Building the project](#building-the-project) below).

#### Prerequisites

Install:
- `spatial` CLI (download instructions for [Linux](https://docs.improbable.io/reference/latest/shared/setup/linux#2-set-up-the-spatialos-cli), [MacOS](https://docs.improbable.io/reference/latest/shared/setup/mac#2-install-spatialos), [Windows](https://docs.improbable.io/reference/latest/shared/setup/win#2-install-spatialos))
- MSBuild (provided by [Mono](https://www.mono-project.com/download/stable/) for Linux and MacOS, [Microsoft.NET](https://www.microsoft.com/en-gb/download/details.aspx?id=30653) for Windows)
- (optional) Bash Terminal (we recommend [GitBash](https://gitforwindows.org/) for Windows)

Run `spatial update` to ensure you have the latest version of the `spatial` command line tool which includes the features required for this example project.

Mac users: ensure that `msbuild` is on your PATH.

Windows users: ensure that `MSBuild.exe` is on your PATH.

Bash is required for running the build script, although as an alternative you can complete the steps manually.

We've tested the project with the following:
* Mono 4.4 (Mac)
* .NET Framework 4.5 (Windows)
* GitBash 2.18 (Windows)

## How do I use it?
The custom layout is enabled by the `spatial` tool detecting a [new-format spatialos.json](https://docs.improbable.io/reference/latest/shared/flexible-project-layout/reference/project-configuration) file. 

We have introduced three new spatial CLI commands under the `alpha` subcommand: `spatial alpha local launch`, `spatial alpha cloud upload` and `spatial alpha cloud launch`. These commands only work for projects using the flexible project layout (FPL). In order to use them, you need to:
* be inside a directory containing a FPL-format `spatialos.json`, **or** 
* reference a FPL-format `spatialos.json` using the `--main_config` flag

You can access this information at any time by using the `--help` flag in the `spatial` command line tool.

## Building the project
Run `./SpatialOS/scripts/build_project.sh` to build the workers and compile the schema descriptor. You can complete these steps manually if required.

Workers are built in their own bin directories:
* HelloWorker: `HelloWorker/bin`
* DiceWorker: `DiceWorker/bin`
* Client: `client/bin`

## Cleaning the project
Run `git clean -xdi` to delete all build files, including worker binaries and any intermediate files generated during the build process.

## Running the project locally
Ensure that your `spatial` CLI is up-to-date (run `spatial update`).

To launch a local instance of SpatialOS running the project, run
```bash
$ spatial alpha local launch
```
from the `SpatialOS` directory (or from any location by adding the `--main_config=<path to your spatialos.json>` flag). This starts SpatialOS locally and runs the server workers `HelloWorker` and `DiceWorker`.

You can optionally set the `--launch_config` flag to specify a filepath to the [launch configuration](https://docs.improbable.io/reference/latest/shared/flexible-project-layout/reference/launch-configuration) of your deployment. If the flag is not set, the spatial CLI will use launch configuration specified in the `launch_config` field of your [project configuration](https://docs.improbable.io/reference/latest/shared/flexible-project-layout/reference/project-configuration) as a fall back.

As soon as your deployment is running, you can connect client-workers to it. You can find the client-worker binaries in `client/bin/x64/ReleaseWindows` (or `ReleaseMacOS` for Mac). Connect your client-worker by opening a second terminal to run the binary directly (from inside the `ReleaseWindows` or `ReleaseMacOS` directories):
* Windows: `./Client.exe localhost 7777 <client-id>`
* macOS: `mono --arch=64 Client.exe localhost 7777 <client-id>`

The `<client-id>` parameter is here to uniquely identify a worker participating in a simulation. It can be an arbitrary unique string of your choice.

This connects a client-worker that pings the `HelloWorker` and `DiceWorker` every few seconds and then prints the response.

### Logs location
The logs are stored in `logs` subdirectory of the location where your `spatialos.json` file is. For example, if my `spatialos.json` file is in `/workspace/project/SpatialOS`, the SpatialOS logs will go to `/workspace/project/SpatialOS/logs`.

## Running the project in the cloud

To upload your project assembly to the cloud:
```bash
$ spatial alpha cloud upload -a <your-assembly-name>
```

To start a deployment in the cloud:
```bash
$ spatial alpha cloud launch -d <your-deployment-name> -a <your-assembly-name>
```

As above, you can run these commands from the `SpatialOS` directory or use the `--main_config=<path to your spatialos.json>` flag to point to your project config when running the commands from another directory.

**Note:** You will not be able to start a client to joint a cloud deployment at the moment.

## Documentation
Documentation for the flexible project layout can be found [here](https://docs.improbable.io/reference/latest/shared/flexible-project-layout/introduction). The documentation includes:
* Configuration file formats
* Project build process
* Guide on setting up new projects for or migrating existing projects to FPL

## Changelog
Changes to this repository are documented [here](changelog.md).
