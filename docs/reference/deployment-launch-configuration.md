## Configuring the deployment (`deployment.json`)

This optional configuration file tells SpatialOS what [deployment template](https://docs.improbable.io/reference/latest/shared/reference/file-formats/launch-config#templates) and runtime flags should be used when starting a deployment.

This file can be passed to `spatial alpha local launch` & `spatial alpha cloud launch` commands via `--launch_config` flag. If this configuration file is not provided, the default `small` template will be used with no `runtimeFlags`.

### Configuration file format

The file may be called by any name but should have the following structure:

```json
{
  "template": "...",
  "runtimeFlags": [
    {
      "name": "...",
      "value": "..."
    }
  ]   
}
```

| Field | Required/Optional | Description | 
| :------------- | :------------- | :------- |
| `template` | Required | Defines the compute resources your deployment needs (i.e., its ‘topology’). See [deployment templates](https://docs.improbable.io/reference/latest/shared/reference/file-formats/launch-config#templates) for more details. |
| `runtimeFlags` | Optional | The runtime flags that can control advanced runtime features. Equivalent to [legacy flags](https://docs.improbable.io/reference/latest/shared/reference/file-formats/launch-config#legacy-flags).|
