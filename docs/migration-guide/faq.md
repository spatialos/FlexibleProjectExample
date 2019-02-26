# FAQ

**How do I specify the SpatialOS SDK version of my project?**<br/>
FPL projects do not have a clearly defined SDK version. You need to keep track of the SDK version(s) that you are using separately. Because you now have full control over which tools and libraries you use when building your project, there is no way for SpatialOS to reliably determine or enforce the SDK version you are using. Note: It is possible for different workers to use different SDK versions in the same project.

**Do you support `spatial worker codegen`, `spatial worker build` and `spatial worker clean`, ?**<br/>
We don't support those commands going forward. The build process of a worker is fully managed by you. For more information, please see [Building a worker executable](../build-process/worker-build-process.md).

**Do you support `spatial local worker launch`?**<br/>
We don't support`spatial local worker launch` going forward. Please start and connect your worker to a deployment manually as shown in the [readme](../../README.md#Running-the-project).

**Do you support `spatial project history snapshot convert`?**<br/>
We don't support `spatial project history snapshot convert` going forward. Please convert the format of your snapshots manually using the [snapshot converter tool](https://docs.improbable.io/reference/latest/shared/operate/snapshots#using-the-snapshot-converter-directly). You can refer to [`convert_snapshot.sh`](../../SpatialOS/scripts/convert_snapshot.sh) for a code example.
