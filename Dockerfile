FROM oven/bun:1-alpine

WORKDIR /app
COPY package.json ./

RUN apk update && apk upgrade --no-cache \
 && bun install --production --no-save \
 && rm -rf /root/.bun/install/cache

COPY src ./src
USER 1000
EXPOSE 3000

CMD ["bun", "--preload", "./src/otel.ts", "./src/index.ts"]