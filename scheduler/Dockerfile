FROM golang:1.26 AS builder

ENV WORKSPACE=/workspace/github.com/carina-io/carina/scheduler
ENV GOMODCACHE=$WORKSPACE/vendor

WORKDIR $WORKSPACE
ADD . .

RUN cd $WORKSPACE/cmd && CGO_ENABLED=0 go build -gcflags '-N -l' -o /tmp/carina-scheduler .

FROM alpine:3.20

COPY --from=builder /workspace/github.com/carina-io/carina/scheduler/debug/scheduler-config.yaml /etc/kubernetes
COPY --from=builder /workspace/github.com/carina-io/carina/scheduler/config.json /etc/carina/
COPY --from=builder /tmp/carina-scheduler /bin/carina-scheduler
RUN chmod +x /bin/carina-scheduler

WORKDIR /bin
CMD ["carina-scheduler"]