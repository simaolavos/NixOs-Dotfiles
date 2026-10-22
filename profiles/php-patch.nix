{ inputs, ... }:
# HACK: unstable has not picked up the fixes for CVE-2026-109618/CVE-2026-109619 (PHP2Shell) yet,
# so take PHP from nixos-26.05 (8.2.35, 8.3.36, 8.4.27, 8.5.12).
# Remove this file (and the nixpkgs-php input) once nixpkgs unstable has PHP >= those versions.
{
  nixpkgs.overlays = [
    (_final: prev:
      let
        patched = inputs.nixpkgs-php.legacyPackages.${prev.stdenv.hostPlatform.system};
      in
      {
        inherit (patched)
          php
          php82
          php83
          php84
          php85
          ;
      })
  ];
}
