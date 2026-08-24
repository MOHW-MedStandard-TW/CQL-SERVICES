FROM mirror.gcr.io/library/node:22-alpine

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

RUN npm install -g pm2

WORKDIR /usr/src/app
COPY ./package.json ./
COPY . .

RUN npm install --omit=dev && npm cache clean --force

RUN mkdir -p /usr/src/app/config/libraries /usr/src/app/config/hooks /usr/src/app/.vsac_cache && \
    chown -R node:node /usr/src/app

EXPOSE 3000
VOLUME ["/usr/src/app/.vsac_cache"]
USER node

CMD [ "pm2-runtime", "start", "cql-es.config.js", "--env", "production" ]