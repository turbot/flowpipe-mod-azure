## v1.0.0 (2024-10-22)

_Breaking changes_

- Flowpipe `v1.0.0` is now required. For a full list of CLI changes, please see the [Flowpipe v1.0.0 CHANGELOG](https://flowpipe.io/changelog/flowpipe-cli-v1-0-0).
- In Flowpipe configuration files (`.fpc`), `credential` and `credential_import` resources have been renamed to `connection` and `connection_import` respectively.
- Renamed all `cred` params to `conn` and updated their types from `string` to `conn`.

_Enhancements_

- Added `library` to the mod's categories.
- Updated the following pipeline tags:
  - `type = "featured"` to `recommended = "true"`
  - `type = "test"` to `folder = "Tests"`

## v0.2.0 [2024-07-24]

_What's new?_

- Added 36 new pipelines for seamless integration with your App Service, Compute, IAM, Key Vault, Network resources, and more.

## v0.1.1 [2024-03-04]

_Bug fixes_

- Fixed mismatched types for `generate_ssh_keys` param in various Compute VM test pipelines.

## v0.1.0 [2023-12-14]

_What's new?_

- Added 45+ pipelines to make it easy to connect your Compute, Network, Storage resources and more. For usage information and a full list of pipelines, please see [Azure Mod for Flowpipe](https://hub.flowpipe.io/mods/turbot/azure).
