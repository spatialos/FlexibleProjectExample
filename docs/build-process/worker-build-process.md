# Building a worker executable
This page explains how to build a [worker](https://docs.improbable.io/reference/latest/shared/glossary#worker) in a SpatialOS project using the flexible project layout (FPL). It also serves as a guide on how to migrate the build process of a worker from the [structured project layout (SPL)](https://docs.improbable.io/reference/latest/shared/reference/project-structure) to the FPL. Refer to our [Migration guide](../migration-guide/migration-guide-master-page.md) for a summary of additional migration steps.

We provide a reference implementation for building a C# worker that includes all worker build steps described in this guide. You can find it in the form of a shell script [here](../../SpatialOS/scripts/build_project.sh).

## Worker build process overview
To build a worker in the FPL, you need to:
1. [Download dependencies](#1-download-dependencies)
2. [Generate code](#2-generate-code)
3. [Build the worker executable](#3-build-the-worker-executable)

**Migration advice:** With the SPL, the spatial CLI performs the worker build steps listed above through a combination of CLI commands ([`spatial worker codegen`](https://docs.improbable.io/reference/latest/shared/spatial-cli/spatial-worker-codegen), [`spatial worker build`](https://docs.improbable.io/reference/latest/shared/spatial-cli/spatial-worker-build)) and configuration files ([`worker build configuration`](https://docs.improbable.io/reference/latest/shared/worker-configuration/worker-build), [`spatialos_worker_packages.json`](https://docs.improbable.io/reference/latest/shared/reference/file-formats/spatial-worker-packages)). With the FPL, you need to perform all build steps manually which gives you full control over the build process.

## 1. Download dependencies
A SpatialOS SDK release consists of a collection of artifacts (libraries, tools etc.). In this build step, you will download the necessary artifacts for building a worker.

**Tip:** You may want to add the dependencies mentioned in this build step to your `.gitignore` file or equivalent to avoid checking them into source control.

### Choose an SDK version
Before you can download any dependencies, you need to be mindful about the SDK version that you want to build your worker with. 
* If you are upgrading a worker from the SPL to the FPL, we recommend you use the SDK version that your project is currently using as specified in your [`project definition file (SPL format)`](https://docs.improbable.io/reference/latest/shared/reference/file-formats/spatialos-json) to reduce the complexity of the migration process.
* If you are creating a worker from scratch, we recommend that you use the same SDK version as other workers in your project.

**Notes:** 
* You can mix SDK versions in an FPL project - in other words, you can build different workers within the same project using different SDK versions. This can be useful when transitioning a project to a newer SDK version - for example, you may opt to upgrade the SDK version of one worker at a time instead of upgrading the full project all at once.
* Since there is no clearly defined SDK version for an FPL project, we recommend that you manually keep track of the SDK version(s) you are using to avoid forgetting that information.

### Download the relevant worker SDK libraries
Worker SDK libraries provide classes and functionalities for connecting with and participating in a SpatialOS simulation. They also provide functionalities for creating and manipulating snapshots.

The choice of worker SDK library depends on the programming language and the target build platform of your worker. See the respective documentation for a full list of available worker SDK libraries:
* C++: [Setting up a C++ worker](https://docs.improbable.io/reference/latest/cppsdk/setting-up)
* C#: (Under construction)
* Java: (Under construction)
* C: [Setting up a worker using the C API](https://docs.improbable.io/reference/latest/capi/setting-up#obtaining-the-sdk)

You can use the `spatial package get` command to download zips that contain the worker SDK libraries of your choice. Below is an example of how to download the C# worker SDK library:

```
spatial package get --force --unzip worker_sdk csharp <my-sdk-version> <my-download-directory>
```

The following command flags are available:
* `--force`: Overwrites the file to be downloaded if it already exists.
* `--unzip`: Unzips the downloaded package. Creates specified directory if it does not exist.

**Migration advice:** You can determine the worker SDK libraries that your existing worker depends on by inspecting the [`spatialos_worker_packages.json`](https://docs.improbable.io/reference/latest/shared/reference/file-formats/spatial-worker-packages) file in the directory of your [worker build configuration](https://docs.improbable.io/reference/latest/shared/worker-configuration/worker-build). In the SPL, the `spatialos_worker_packages.json` specifies the worker SDK libraries that the spatial CLI would automatically download for you while building a worker.

### Download the standard schema library
The [standard schema library](https://docs.improbable.io/reference/latest/shared/schema/standard-schema-library) is a collection of `.schema` files that contain common SpatialOS components. Some standard schema library components are mandatory for all SpatialOS entities.

To download the schema standard library, run:
```
spatial package get --force --unzip schema standard_library <my-sdk-version> <my-download-directory>
```

### Download the schema compiler
The schema compiler is a tool for generating SpatialOS components API code from schema. 

To download the schema compiler, run:
```
spatial package get --force --unzip tools schema_compiler-x86_64-<my-target-platform> <my-sdk-version> <my-download-directory>
```
`<my-target-platform>` denotes the operating system of the machine that will run the schema compiler, and must be one of `win32`, `macos`, or `linux`.

**Tip:** You will also use the schema compiler when you come to generate a schema descriptor. For more information, see [Building a schema descriptor in the FPL](schema-descriptor-build-process.md).

## 2. Generate code
In this build step, you use the schema compiler to generate API code for interacting with SpatialOS components from schema. You can regard the generated code as library code that your worker calls as part of its simulation logic.

For more details on how to use the schema compiler and a full list of supported operations, see its [documentation](https://docs.improbable.io/reference/latest/shared/schema/introduction#using-the-schema-compiler-directly).

Below is an example of how to generate component API code for C#:
```
schema_compiler  --schema_path=<my-schema-dir>  --schema_path=<schema-std-lib-dir>  --csharp_out=<generated-output-dir> --load_all_schema_on_schema_path   <my-schema-dir>/*.schema <schema-std-lib-dir>/*.schema
```
**Note:** You need to perform this build step whenever you change your project’s schema as you iterate on your game, to make sure the generated code for your worker is up-to-date.

**Tip:** You may want to add the generated code to your `.gitignore` file or equivalent to avoid checking it into source control.

## 3. Build the worker executable
In this final build step, you will use a build tool or process of your choice to compile your worker source into an executable binary. Make sure to reference both the worker SDK libraries and the generated API code as build dependencies of your worker.

The build process is fully customisable to the specific requirements of your worker. You might make use of a widely known build tool like CMake or MSBuild, or rely on a build system specific to your game engine.

**Migration advice:** You can easily determine the build process of your existing worker by inspecting the `tasks` list in the `build` section of its [worker configuration file](https://docs.improbable.io/reference/latest/shared/worker-configuration/worker-build#using-custom-build-scripts). In the SPL, the `tasks` list specifies which commands and arguments the spatial CLI should run under the hood when building a worker. Note: The `tasks` list may also be specified in a separate tasks file, usually called `<my-worker>.build.json`. The tasks file is referenced in the `build.tasks_filename` field of your worker configuration in that case.

### How can I verify that my worker was built correctly?
* If you are migrating an existing worker from the SPL to the FPL, you can compare the built out worker executables for equality.
* If you are creating a new worker from scratch, you can start a deployment locally and see if your built out worker can connect to it. If your worker is a [server-worker](https://docs.improbable.io/reference/latest/shared/glossary#server-worker), you will need to specify a [load balancing configuration](https://docs.improbable.io/reference/latest/shared/worker-configuration/load-balancing#load-balancing) and a [worker configuration file](../reference/server-worker-configuration.md) and the SpatialOS Runtime will automatically start a worker instance for you.
