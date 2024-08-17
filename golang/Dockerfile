from golang:1.23-alpine

EXPOSE 8080/tcp

# Use numerical uid/gid so that k8s is happy
RUN adduser -h /app -s /bin/bash -g app -D -u 1200 app
USER 1200:1200


COPY --chown=1200:1200 ./main.go /app/main.go
COPY --chown=1200:1200 ./go.mod /app/go.mod

WORKDIR /app

RUN go mod download
RUN go build main

ENTRYPOINT ./main
