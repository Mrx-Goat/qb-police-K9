# MRX Police K9

A lightweight FiveM police K9 resource with QBCore and ESX support.

## Features

- Spawn and return a police K9 at configured kennels
- Follow, stay, attack, search and vehicle behavior
- Player, trunk and glovebox searches
- Job, rank and optional item restrictions
- `qb-target` and `ox_target` support
- QBCore enabled by default

## Requirements

- FiveM server artifact with Lua 5.4 support
- QBCore or ESX
- `qb-target` or `ox_target`
- `oxmysql`
- A supported inventory export for vehicle searches

## Installation

1. Copy this repository into your resources folder.
2. Rename the resource folder if desired.
3. Review `config.lua` and enable exactly one framework.
4. Confirm `Config.ThirdEyeName` matches your target resource.
5. Add `ensure <resource-folder-name>` to `server.cfg`.
6. Restart the server and test on a development server first.

## Important configuration

```lua
Config.UseESX = false
Config.UseQBCore = true
Config.ThirdEyeName = 'qb-target'
```

Do not enable ESX and QBCore at the same time.

## Inventory compatibility

The QBCore vehicle search expects these exports from `qb-inventory`:

```lua
exports['qb-inventory']:getGloveboxItems(plate)
exports['qb-inventory']:getTrunkItems(plate)
```

If your inventory uses different export names or data structures, update the two helper functions at the bottom of `server.lua`.

## Safety notes

- All search callbacks now return `false` when a player, vehicle or item is missing.
- Client searches wait for the server callback before showing a K9 alert.
- Test framework and inventory updates in a non-production server before deployment.

## License

See the repository `LICENSE` file.
