FROM node:12-alpine
ENV WORKDIR /usr/src/app/dev/
WORKDIR $WORKDIR
COPY package*.json $WORKDIR

RUN npm install --production --no-cache && npm install -g @contrast/node-contrast
