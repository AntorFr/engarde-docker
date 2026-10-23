# syntax=docker/dockerfile:1
#
# engarde (https://github.com/porech/engarde) has no official image nor tagged
# releases: we build it from a pinned upstream commit. Bump ENGARDE_REF on purpose.
ARG ENGARDE_REF=3492df906049826c226996b50224f963ee37bdf3

# --- Upstream source ---------------------------------------------------------------
FROM --platform=$BUILDPLATFORM golang:1.27.3-alpine3.24 AS source
ARG ENGARDE_REF
RUN apk add --no-cache git
RUN git clone https://github.com/porech/engarde.git /src \
 && git -C /src checkout --quiet "$ENGARDE_REF"

# --- Web manager (Angular), embedded into the binaries -----------------------------
FROM --platform=$BUILDPLATFORM node:22.23.4-alpine3.24 AS frontend
COPY --from=source /src/webmanager /webmanager
WORKDIR /webmanager
RUN npm ci --no-audit --no-fund && npm run build-prod

# --- Go binaries -------------------------------------------------------------------
FROM --platform=$BUILDPLATFORM golang:1.27.3-alpine3.24 AS build
ARG ENGARDE_REF
COPY --from=source /src /src
COPY --from=frontend /webmanager/dist/webmanager/browser /src/internal/assets/browser
WORKDIR /src
ENV CGO_ENABLED=0

FROM build AS build-server
ARG TARGETOS
ARG TARGETARCH
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build \
      -ldflags "-s -w -X 'main.Version=$(echo $ENGARDE_REF | head -c 7)'" \
      -o /out/engarde-server ./cmd/engarde-server

# macOS client, for the laptop side. Not part of the image:
#   docker build --target client-darwin --output client/.bin .
FROM build AS build-client-darwin
RUN GOOS=darwin GOARCH=arm64 go build \
      -ldflags "-s -w -X 'main.Version=$(echo $ENGARDE_REF | head -c 7)'" \
      -o /out/engarde-client ./cmd/engarde-client

FROM scratch AS client-darwin
COPY --from=build-client-darwin /out/engarde-client /

# --- Runtime -----------------------------------------------------------------------
FROM alpine:3.24.3
COPY --from=build-server /out/engarde-server /usr/local/bin/engarde-server
USER 65532:65532
# 59402/udp: clients, 9001/tcp: web manager.
EXPOSE 59402/udp 9001/tcp
ENTRYPOINT ["/usr/local/bin/engarde-server"]
CMD ["/config/engarde.yml"]
