# Building a schema descriptor
This page explains how to build a schema descriptor in a SpatialOS project that’s using the flexible project layout (FPL).

## Schema descriptor introduction 
The schema descriptor is a build artifact of a SpatialOS project [assembly](https://docs.improbable.io/reference/13.6/shared/glossary#assembly). It allows the SpatialOS Runtime to interpret your project’s schema and is necessary for starting a SpatialOS deployment both locally and in the cloud. You can generate a schema descriptor using the [schema compiler tool](https://docs.improbable.io/reference/latest/shared/schema/introduction#using-the-schema-compiler-directly).

**Note:** In the [structured project layout (SPL)](https://docs.improbable.io/reference/latest/shared/reference/project-structure), the spatial CLI automatically generates the schema descriptor. For an FPL project, you need to manually generate your schema descriptor.

## Schema descriptor build process
1. [Download the schema compiler](worker-build-process.md#download-the-schema-compiler).
2. Invoke the schema compiler as follows:
```
schema_compiler  --schema_path=<my-schema-dir>  --schema_path=<schema-std-lib-dir>  --descriptor_set_out=<schema-descriptor-output-dir> --load_all_schema_on_schema_path   <my-schema-dir>/*.schema <schema-std-lib-dir>/*.schema
```

**Note:**
* You need to specify the file path to your schema descriptor in your [project configuration file](../reference/project-configuration.md) to allow the SpatialOS Runtime to find your schema descriptor.
* You need to regenerate your schema descriptor whenever you change your project’s schema as you iterate on your game. 
* You may want to add the schema descriptor to your `.gitignore` file or equivalent to avoid checking it into source control.
