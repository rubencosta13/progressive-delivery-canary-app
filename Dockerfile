FROM oven/bun:1-alpine

RUN apk update && apk upgrade --no-cache

WORKDIR /app
COPY package.json ./
RUN bun install --production --no-save

RUN rm -rf /root/.bun/install/cache

COPY src ./src
USER bun
EXPOSE 3000

CMD ["bun", "--preload", "./src/otel.ts", "./src/index.ts"]