{
  description = "A flake building ente-desktop from its AppImage";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    package_name = "thorium";
    package_version = "130.0.6723.174";
  in {
    overlays.default = final: prev: {
      thorium = self.packages.${prev.system}.default;
    };

    packages.${system}.default = with pkgs;
      appimageTools.wrapType2 rec {
        pname = package_name;
        version = package_version;

        src = fetchurl {
          url = "https://github.com/Alex313031/thorium/releases/download/M130.0.6723.174/Thorium_Browser_130.0.6723.174_AVX2.AppImage";
          hash = "sha256-Ej7OIdAjYRmaDlv56ANU5pscuwcBEBee6VPZA3FdxsQ=";
        };

        extraInstallCommands = let
          extracted = appimageTools.extractType2 {inherit pname version src;};
        in ''
          install -m 444 -D ${extracted}/thorium-browser.desktop -t $out/share/applications
          cp -r ${extracted}/usr/share/icons $out/share
        '';

        meta = with lib; {
          description = "Thorium Browser";
          homepage = "https://thorium.rocks";
          downloadPage = "https://github.com/Alex313031/thorium";
          license = licenses.bsd3;
          sourceProvenance = with sourceTypes; [binaryNativeCode];
          maintainers = with maintainers; [fn3x];
          platforms = ["x86_64-linux"];
        };
      };
  };
}
