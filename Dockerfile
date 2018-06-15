FROM alpine:3.5 AS base
RUN apk add --no-cache nodejs-current tini
COPY package.json .

ENV NODE_ENV=production
RUN npm set progress=false && npm config set depth 0
RUN npm install --only=production



FROM base AS release
COPY index.js .

EXPOSE 8888
CMD [ "npm", "start" ]
