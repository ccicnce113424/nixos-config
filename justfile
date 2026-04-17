fmt:
    nix fmt .

fup:
    nix flake update --commit-lock-file

pf *args:
    nix store prefetch-file {{ args }}
