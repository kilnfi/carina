FROM golang:1.26 AS builder

WORKDIR /workspace
COPY go.mod go.sum ./
RUN go mod download
COPY . .

RUN cd cmd && CGO_ENABLED=0 go build -o /tmp/carina-scheduler .

FROM alpine:3.20

COPY --from=builder /workspace/debug/scheduler-config.yaml /etc/kubernetes
COPY --from=builder /workspace/config.json /etc/carina/
COPY --from=builder /tmp/carina-scheduler /bin/carina-scheduler

CMD ["carina-scheduler"]
