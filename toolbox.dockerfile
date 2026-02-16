FROM localhost/nixbuilder as builder

FROM registry.fedoraproject.org/fedora-toolbox:43 as runner

# copy nix files
COPY --from=builder /out/nix /nix
COPY --from=builder /out/root/.nix-profile /nix/.nix-profile

ENV PATH=/nix/.nix-profile/bin:/bin:/usr/bin \
    LANG=C.UTF-8

RUN ln -s /nix/.nix-profile/bin/fish /usr/bin/fish
