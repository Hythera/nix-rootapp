<p align="center">
    <a href="https://www.rootapp.com/"><img src=".github/assets/nix-rootapp.png" alt="Nix Rootapp" height=170></a>
</p>
<h1 align="center">Nix Rootapp</h1>

<p align="center">
<a href="https://www.rootapp.com/download" target="_blank"><img height=20 src="https://img.shields.io/badge/version-0.9.75-blue" /></a>
<img src="https://img.shields.io/github/stars/Hythera/nix-rootapp" alt="stars">
</p>

<div align="center">
  <a href="https://www.rootapp.com/">Root</a>
  <span>&nbsp;&nbsp;•&nbsp;&nbsp;</span>
  <a href="https://github.com/Hythera/nix-rootapp/issues/new">Issues</a>
  <span>&nbsp;&nbsp;•&nbsp;&nbsp;</span>
  <a href="https://www.rootapp.com/changelog">Changelog</a>
  <br />
</div>

## What is Nix Rootapp?

Because NixOS differs from most Linux distributions, **Root** has to be packaged manually. Nix Rootapp provides support for NixOS to **Root** through a flake, by packaging the AppImage and providing runtime libraries.

## Why not in nixpkgs?

**Root** is currently in closed beta, making it ineligible to be added to `nixpkgs`. Additionally, packaging **Root** for **Nix** is challenging as it doesn't have a versioned download. Instead, it uses a single download link that updates with every version, breaking the hash in the process.

## Install

This flake only supports Linux (`x86_64` & `aarch64`). While **Root** itself supports Linux, macOS, and Windows, if you are not on NixOS and Linux, check out their [Download Page](https://www.rootapp.com/download) to get **Root** for your platform.

### Run Root without installing

You can test Root on your system by using the provided dev shell.

```bash
# run the nix shell (requires the new experimental nix command)
nix shell github:Hythera/nix-rootapp

# start root
rootapp
```

### Home Manager module

You can also install Root with [Home Manager](https://github.com/nix-community/home-manager).

```nix
# flake.nix
{
  inputs = {
    rootapp.url = "github:Hythera/nix-rootapp";
    ...
  };
  outputs = {
    nixpkgs,
    home-manager,
    rootapp, # pass rootapp to outputs
  }: let
    system = "...";
    pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."..." = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          rootapp.homeManagerModules.default # enable the Home Manager moduel
          ...
        ]
      }
    }
}
```

```nix
# home.nix
{
  pkgs,
  ...
}: {
  programs.rootapp.enable = true; # enable root; defaults to false
}
```

### System Package

The last way is to install Root with the default NixOS configuration.

```nix
# flake.nix
{
  inputs = {
    rootapp.url = "github:Hythera/nix-rootapp";
    ...
  };
  outputs = {
    nixpkgs,
    home-manager,
    rootapp, # pass rootapp to outputs
  }: let
    system = "...";
    in {
      nixosConfigurations."..." = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./configuration.nix
          ...
        ];
      };
    }
}
```

```nix
# configuration.nix
{ 
  inputs, 
  ...
}:
{
  environment.systemPackages = [
    inputs.rootapp
  ]
}

```
