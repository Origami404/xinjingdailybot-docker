FROM alpine:3 AS builder

RUN apk add --no-cache \
    wget \
    unzip

RUN wget https://github.com/chr233/XinjingdailyBot/releases/download/2.2.4.11/linux-x64-fde.zip \
 && unzip linux-x64-fde.zip -d /app

RUN chmod +x /app/XinjingdailyBot.WebAPI

FROM debian:12 AS final

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    libicu72 \
    libssl3 \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/XinjingdailyBot.WebAPI /app/nlog.config /app/

WORKDIR /app
CMD ["./XinjingdailyBot.WebAPI"]
