{
  description = "AB Download Manager packaged for Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      mkUpdate =
        pkgs:
        pkgs.writeShellApplication {
          name = "update-ab-download-manager";
          runtimeInputs = with pkgs; [
            coreutils
            curl
            jq
            nix
          ];
          text = builtins.readFile ./scripts/update.sh;
        };
    in
    {
      overlays.default = final: _: {
        ab-download-manager = final.callPackage ./package.nix { };
      };

      packages = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
          package = pkgs.ab-download-manager;
        in
        {
          default = package;
          ab-download-manager = package;
        }
      );

      apps = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
          package = self.packages.${system}.ab-download-manager;
          update = mkUpdate pkgs;
        in
        {
          default = {
            type = "app";
            program = "${package}/bin/ABDownloadManager";
            meta.description = "Run AB Download Manager";
          };
          ab-download-manager = self.apps.${system}.default;
          cli = {
            type = "app";
            program = "${package}/bin/ABDownloadManagerCli";
            meta.description = "Run the AB Download Manager command-line client";
          };
          update = {
            type = "app";
            program = "${update}/bin/update-ab-download-manager";
            meta.description = "Update AB Download Manager source metadata";
          };
        }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
          package = self.packages.${system}.ab-download-manager;
        in
        {
          inherit package;

          package-layout = pkgs.runCommand "ab-download-manager-package-layout" { } ''
            test -x ${package}/bin/ABDownloadManager
            test -x ${package}/bin/ABDownloadManagerCli
            test -x ${package}/bin/ABDownloadManagerNativeMessagingHost
            test -f ${package}/share/applications/com.abdownloadmanager.desktop
            test -f ${package}/lib/mozilla/native-messaging-hosts/com.abdownloadmanager.json
            touch "$out"
          '';
        }
      );

      formatter = forAllSystems (system: (mkPkgs system).nixfmt-tree);

      devShells = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
        in
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              actionlint
              jq
              nixfmt-tree
              shellcheck
            ];
          };
        }
      );

      homeModules = {
        default = import ./modules/home-manager.nix;
        ab-download-manager = self.homeModules.default;
      };
    };
}
