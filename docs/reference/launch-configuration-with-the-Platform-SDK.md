# Starting a deployment using the Platform SDK

**Note:** The current workflow is temporary, and this command is only available in `spatial alpha`. We will have a better workflow in the future.

The [flexible project layout (FPL) launch configuration file](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/launch-configuration.md) has a different format from the [current project layout (SPL) launch configuration file](https://docs.improbable.io/reference/latest/shared/reference/file-formats/launch-config#launch-configuration-file). You can find more details about the difference between the two formats [here](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/migration-guide/configs-conversion-guide.md#converting-the-launch-configuration-file).

The Platform SDK currently only works with the SPL launch configuration format, so you need to convert your launch configuration file back to SPL format before you can use it with the Platform SDK. We’ve added a command that does this for you.

## How do I use it?
To convert an FPL launch configuration file to its SPL equivalent, run the following command inside the directory containing your FPL-format `spatialos.json`:
```bash
spatial alpha config convert
```
By default, we will create a file called `spl_launch.json` containing the converted launch configuration. If you want to give the resulting file a different name or save it in a different place, you can set the `--output_path` flag to specify a filepath to the SPL launch configuration file:
```bash
spatial alpha config convert --output_path <output-path>
```
You can now use this file with the [Platform SDK](https://docs.improbable.io/reference/latest/platform-sdk/introduction).
