FROM golang:1.27 AS build
WORKDIR /src
COPY go.mod ./
COPY cmd/skills ./cmd/skills
RUN CGO_ENABLED=0 go build -o /skills ./cmd/skills

FROM gcr.io/distroless/static-debian12
COPY --from=build /skills /skills
EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["/skills"]
