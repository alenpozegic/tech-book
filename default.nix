{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs {}
, gitrev ? "devel"
, inShell ? null
}:

let

  haskellDeps = ps: with ps; [
    base
    shake
  ];

  ghc = pkgs.haskellPackages.ghcWithPackages haskellDeps;

  fontsConf = pkgs.makeFontsConf {
    fontDirectories = [
      pkgs.dejavu_fonts
      pkgs.lora
    ];
  };

  envVars = ''
    export GITREV="${gitrev}"
    export FONTCONFIG_FILE="${fontsConf}"
  '';

  src = builtins.filterSource
    (path: type:
      (type != "directory" || baseNameOf path != ".git")
      && (type != "directory" || baseNameOf path != ".jj")
      && (type != "directory" || baseNameOf path != "_build")
      && (type != "symlink" || baseNameOf path != "result"))
    ./.;

  deps = with pkgs; [
    pandoc
    pandoc-include
    haskellPackages.pandoc-crossref
    luaPackages.luacheck
    typst
    shake
    ghc ghcid hlint
    entr
  ];

  env = pkgs.mkShell {
    buildInputs = deps ++ [
    ];
    shellHook = ''
      ${envVars}
    '';
  };

  drv = pkgs.stdenv.mkDerivation {
      name = "tech-book";
      src = src;
      nativeBuildInputs = deps ++ [
      ];
      buildPhase = ''
        ${envVars}
        shake
      '';
      installPhase = ''
        mkdir -p "$out"
        cp -a _build/* $out
      '';
  };

in if inShell == false
   then drv
   else if pkgs.lib.inNixShell then env else drv

