
# nRF Connect (nrf-connect)

Tools for developing with devices supporting nRF Connect

## Example Usage

```json
"features": {
    "ghcr.io/nrfconnect/devcontainer/nrf-connect:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| sdkVersion | - | string | v2.4.0 |
| projectType | This determines whether the SDK should be installed globally on the machine. | string | workspace |
| initializeWorkspaceProject | Initializes a workspace project on startup. This only has an effect if `projectType` is set to `workspace`. | boolean | true |

## Customizations

### VS Code Extensions

- `nordic-semiconductor.nrf-connect-extension-pack`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/nrfconnect/devcontainer/blob/main/feature/nrf-connect/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
