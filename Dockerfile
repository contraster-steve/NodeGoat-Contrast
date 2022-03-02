FROM node:12-alpine

RUN apk --update add bash nano g++ gcc make autoconf automake alpine-sdk linux-headers python3 py3-pip

ENV WORKDIR /usr/src/app/
WORKDIR $WORKDIR
COPY package*.json $WORKDIR
RUN npm install --production --no-cache && npm install @contrast/agent --no-optional
RUN npm install --production --no-cache

ENV USER node
ENV WORKDIR /home/$USER/app/dev/
WORKDIR $WORKDIR
COPY --from=0 /usr/src/app/node_modules /home/$USER/app/dev/node_modules
RUN chown $USER:$USER $WORKDIR
COPY --chown=node . $WORKDIR
# In production environment uncomment the next line
#RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR
# Then all further actions including running the containers should be done under non-root user.
USER $USER
EXPOSE 4000
