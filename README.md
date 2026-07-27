# AB Download Manager for Nix

An unofficial Nix package for [AB Download Manager](https://github.com/amir1376/ab-download-manager).

The package supports `x86_64-linux` and `aarch64-linux`.

## Run or install

```bash
nix run github:so1ve/ab-download-manager-nix
nix profile install github:so1ve/ab-download-manager-nix
```

The cli client is also exposed:

```bash
nix run github:so1ve/ab-download-manager-nix#cli -- --help
```

## Use as a Flake input

```nix
{
  inputs.ab-download-manager = {
    url = "github:so1ve/ab-download-manager-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, ab-download-manager, ... }: {
    nixosConfigurations.my-host = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ ab-download-manager.overlays.default ];
          environment.systemPackages = [ pkgs.ab-download-manager ];
        })
      ];
    };
  };
}
```

In an ordinary NixOS module, after adding the overlay, use:

```nix
environment.systemPackages = [
  (pkgs.ab-download-manager.override {
    uiScale = 2;
  })
];
```

`uiScale` defaults to `null`, which leaves scaling to Java and the desktop
environment.

## Home Manager

The Home Manager module installs the package, registers the Firefox native messaging host, and installs the official Firefox extension:

```nix
{
  imports = [ inputs.ab-download-manager.homeModules.default ];

  programs.ab-download-manager = {
    enable = true;
    uiScale = 2;
  };
}
```

Firefox integration can be adjusted with:

```nix
programs.ab-download-manager.browserIntegration.firefox = {
  enable = true;
  installExtension = false;
};
```

## Updates

As a Flake consumer, run:

```bash
nix flake update ab-download-manager
```

To update the package metadata manually:

```bash
nix run .#update
nix run .#update -- 1.10.2
```

The update command reads the official GitHub Release API and updates the hashes for both Linux architectures. GitHub Actions automatically tracks and publishes upstream updates.

Release tags follow `v<upstream-version>-<packaging-revision>`, for example `v1.10.2-1`. The wrapper does not re-upload upstream archives.

## Development

```bash
nix flake check
nix fmt
nix develop
```

## LICENSE

MIT. Made with ❤️ and AI assistance by [Ray](https://github.com/so1ve)

- AB Download Manager is licensed under Apache-2.0.
