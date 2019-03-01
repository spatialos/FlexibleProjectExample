# Migrating a SpatialOS project to the FPL
This page presents a step-by-step guide on how to migrate a SpatialOS project from the [structured project layout (SPL)](https://docs.improbable.io/reference/latest/shared/reference/project-structure) to the flexible project layout (FPL).

## Overview
To migrate a SpatialOS project from the SPL to the FPL, you need to:
1. [Migrate your workers](#1-migrate-your-workers)
2. [Migrate your launch configuration file](#2-migrate-your-launch-configuration-files)
3. [Migrate your project definition file](#3-migrate-your-project-definition-file)
4. [Generate a schema descriptor](#4-generate-a-schema-descriptor)
5. [Verify the integrity of your project](#5-verify-the-integrity-of-your-project)
6. [Customise your project folder structure](#6-customise-your-project-folder-structure)

**Note:** Migrating a SpatialOS project from SPL to FPL is an all or nothing process. A project must either fully follow the SPL format or the FPL format and cannot have partially migrated components.

**Tip:** We recommend that you back up a copy of your project before you start migrating so that you can recover information from files that you delete as part of the migration process if needed.

## 1. Migrate your workers
1. Migrate the build process of your workers by following the steps in [Building a worker executable](../build-process/worker-build-process.md).
2. Migrate your workers’ worker configuration files by following the steps in [Converting the worker configuration file](configs-conversion-guide.md#converting-the-worker-configuration-file).
3. Delete all previous SPL format configuration files related to the configuration and build process of your workers. Those configuration files include:
    - Your SPL format [worker configuration files](https://docs.improbable.io/reference/latest/shared/worker-configuration/worker-configuration)
    - Your SPL format [worker build configuration files](https://docs.improbable.io/reference/latest/shared/worker-configuration/worker-build)
    - [spatialos_worker_packages.json files](https://docs.improbable.io/reference/latest/shared/reference/file-formats/spatial-worker-packages)

## 2. Migrate your launch configuration files
**Note:** If you want to use the [Platform SDK](https://docs.improbable.io/reference/latest/platform-sdk/introduction), you should **not** convert your launch configuration file into FPL format. The Platform SDK currently only works with SPL format launch configuration files.
1. Migrate your launch configuration files by following the steps in [Converting the launch configuration file](configs-conversion-guide.md#converting-the-launch-configuration-file).
2. Delete your previous SPL format launch configuration file.

## 3. Migrate your project definition file
1. Migrate your project definition file by following the steps in [Converting the project definition file](configs-conversion-guide.md#converting-the-project-definition-file).
2. Delete your previous SPL format project definition file.

## 4. Generate a schema descriptor
Generate a schema descriptor by following the steps in [Building a schema descriptor](../build-process/schema-descriptor-build-process.md).

## 5. Verify the integrity of your project
Your project is now in a state where it complies with the FPL and can be run.
1. Run `spatial alpha local launch` and verify that your deployment behaves how it did pre-migration.
2. Run `spatial alpha cloud upload -a <some-assembly-name>` and verify that this uploads your project assembly correctly to `https://console.improbable.io/projects/<your-project-name>/assemblies`. Your project assemblies should contain your schema descriptor and a zip file for each worker and each supported platform in your project. Each worker zip file should contain the content from the `localBuildDirectory` folder of the worker configuration file.
3. Run `spatial alpha cloud launch -d <your-deployment-name> - a <your-assembly-name>` and verify that your deployment behaves how it did pre-migration.

## 6. Customise your project folder structure
You have successfully migrated your project to the FPL. Congratulations! You now have the freedom to customise your project’s folder structure in ways that were not possible in the SPL.
For example:
- you can freely choose where you store your project schema. You just need to make sure that the schema compiler finds all relevant schema files as you generate code or the schema descriptor.
- you can freely choose where you store your worker projects and change the build process. You just need to make sure you update:
  * the references to your worker configuration files in your project configuration file
  * the `localBuildDirectory` fields in each worker configuration file.
