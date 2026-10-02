fmt:
    nix fmt .

fup:
    nix flake update --commit-lock-file

pr *args:
    nix run .#nixpkgs-prs -- {{ args }}
