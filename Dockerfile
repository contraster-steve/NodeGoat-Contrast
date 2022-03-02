FROM node:12-alpine
ENV WORKDIR /usr/src/app/dev/
WORKDIR $WORKDIR
COPY package*.json $WORKDIR
COPY node-contrast*.tgz $WORKDIR
RUN npm install --production --no-cache && npm install node-contrast*.tgz
RUN npm install --production --no-cache

FROM node:12-alpine
ENV USER node
ENV WORKDIR /home/$USER/app/dev/
WORKDIR $WORKDIR
COPY --from=0 /usr/src/app/dev/node_modules node_modules
RUN chown $USER:$USER $WORKDIR
COPY --chown=node . $WORKDIR
# In production environment uncomment the next line
#RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR
# Then all further actions including running the containers should be done under non-root user.
USER $USER
EXPOSE 4000
