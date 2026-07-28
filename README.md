# so1ve/nur-packages

Ray's personal [NUR](https://github.com/nix-community/NUR) repository

## NUR

After enabling NUR, install a package through its repository attribute:

```nix
environment.systemPackages = [
  pkgs.nur.repos.so1ve.ab-download-manager
];
```

Published Home Manager modules are available through
`inputs.nur.repos.so1ve.homeModules` when NUR is used as a flake input.

## Flake

Run or install a package directly:

```bash
nix run github:so1ve/nur-packages#ab-download-manager
nix profile install github:so1ve/nur-packages#ab-download-manager
```

Or add the repository as a flake input:

```nix
{
  inputs.so1ve-nur = {
    url = "github:so1ve/nur-packages";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Packages are exposed through `packages` and modules through `homeModules`.

## Packages

| Attribute | Documentation |
| --- | --- |
| `ab-download-manager` | [Usage](pkgs/ab-download-manager/README.md) |
| `r-maple-mono-nf-cn` | [Usage](pkgs/r-maple-mono-nf-cn/README.md) |
