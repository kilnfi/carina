# Build the manager binary
FROM golang:1.26 AS builder

WORKDIR /workspace
COPY go.mod go.sum ./
RUN go mod download
COPY . .

RUN cd cmd/carina-node && CGO_ENABLED=0 go build -o /tmp/carina-node .
RUN cd cmd/carina-controller && CGO_ENABLED=0 go build -o /tmp/carina-controller .

FROM alpine:3.20

RUN apk add --no-cache bash bcache-tools device-mapper e2fsprogs eudev lvm2 parted thin-provisioning-tools util-linux xfsprogs

COPY --from=builder /tmp/carina-node /usr/bin/
COPY --from=builder /tmp/carina-controller /usr/bin/
COPY --from=builder /workspace/debug/hack/config.json /etc/carina/

CMD ["carina-controller"]
