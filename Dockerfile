FROM oven/bun:1-alpine

WORKDIR /app

COPY package.json yarn.lock ./

RUN bun install --production

COPY src ./src

USER bun

EXPOSE 3000

CMD ["bun", "--preload", "./src/otel.ts", "./src/index.ts"]