FROM localhost/nixbuilder as builder

FROM alpine AS runner
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     ca-certificates \
#     bash \
#  && rm -rf /var/lib/apt/lists/*

# copy nix files
COPY --from=builder /out/nix /nix
COPY --from=builder /out/root /root
COPY --from=builder /out/root/.config /root/.config
COPY --from=builder /out/root/.nix-profile /root/.nix-profile

ENV HOME=/root \
    PATH=/root/.nix-profile/bin:/bin:/usr/bin \
    LANG=C.UTF-8

WORKDIR /workspace
ENTRYPOINT ["fish"]
