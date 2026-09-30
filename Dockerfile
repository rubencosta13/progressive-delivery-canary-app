FROM oven/bun:1-alpine

WORKDIR /app

COPY package.json ./

RUN bun install --production --no-save

COPY src ./src

USER bun

EXPOSE 3000

CMD ["bun", "--preload", "./src/otel.ts", "./src/index.ts"]