{
  callPackage,
  fetchurl,
  lib,
  stdenvNoCC,
  unzip,
}:

let
  release = builtins.fromJSON (builtins.readFile ./sources.json);
  source = release.sources.all;
  updater = callPackage ../../tools/github-release-updater { } {
    name = "r-maple-mono-nf-cn";
    config = ./update.json;
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "r-maple-mono-nf-cn";
  inherit (release) version;

  src = fetchurl {
    url = "https://github.com/so1ve/maple-font/releases/download/v${finalAttrs.version}/${source.asset}";
    inherit (source) hash;
  };

  nativeBuildInputs = [ unzip ];
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/fonts/truetype"
    unzip -q -j "$src" '*.ttf' -d "$out/share/fonts/truetype"

    runHook postInstall
  '';

  passthru = {
    inherit updater;
    updateScript = lib.getExe updater;
  };

  meta = {
    description = "R Maple Mono with Nerd Font icons and CJK glyphs";
    homepage = "https://github.com/so1ve/maple-font";
    changelog = "https://github.com/so1ve/maple-font/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
