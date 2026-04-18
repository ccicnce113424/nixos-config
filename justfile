fmt:
    nix fmt .

fup:
    nix flake update --commit-lock-file

pr:
    nix run .#update-prs
