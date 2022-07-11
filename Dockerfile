FROM node:16-alpine AS Builder

RUN corepack enable
RUN corepack prepare pnpm@v7.5.0 --activate

WORKDIR /app
COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile
COPY . /app
RUN pnpm build



FROM node:16-alpine AS Worker

COPY --from=Builder /app/dist/server.js /app

EXPOSE 3000

CMD ["node", "server.js"]