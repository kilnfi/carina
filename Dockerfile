# Build the manager binary
FROM golang:1.26 AS builder

ENV WORKSPACE=/workspace/github.com/carina-io/carina
ENV GOMODCACHE=$WORKSPACE/vendor

WORKDIR $WORKSPACE
ADD . .

# Build
RUN echo Commit: `git log --pretty='%s%b%B' -n 1`
RUN cd $WORKSPACE/cmd/carina-node && CGO_ENABLED=0 go build -ldflags="-X main.gitCommitID=`git rev-parse HEAD`" -gcflags '-N -l' -o /tmp/carina-node .
RUN cd $WORKSPACE/cmd/carina-controller && CGO_ENABLED=0 go build -ldflags="-X main.gitCommitID=`git rev-parse HEAD`" -gcflags '-N -l' -o /tmp/carina-controller .

FROM alpine:3.20

RUN apk add --no-cache lvm2 device-mapper e2fsprogs xfsprogs util-linux parted

COPY --from=builder /tmp/carina-node /usr/bin/
COPY --from=builder /tmp/carina-controller /usr/bin/
COPY --from=builder /workspace/github.com/carina-io/carina/debug/hack/config.json /etc/carina/

CMD ["echo", "carina-node", "carina-controller"]
