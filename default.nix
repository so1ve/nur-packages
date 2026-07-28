{
  pkgs ? import <nixpkgs> { },
}:

{
  ab-download-manager = pkgs.callPackage ./pkgs/ab-download-manager { };
  r-maple-mono-nf-cn = pkgs.callPackage ./pkgs/r-maple-mono-nf-cn { };

  homeModules = import ./home-modules;
}
