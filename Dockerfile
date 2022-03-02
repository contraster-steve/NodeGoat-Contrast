FROM node:16-alpine as installer
ENV WORKDIR /usr/src/app/dev/
WORKDIR $WORKDIR
COPY package*.json $WORKDIR
RUN npm install --production --no-cache && npm install @contrast/agent --no-optional

FROM node:16-alpine
ENV USER node
ENV WORKDIR /home/$USER/app/dev/
WORKDIR $WORKDIR
COPY --from=0 /usr/src/app/dev/node_modules $WORKDIR/node_modules
RUN chown $USER:$USER $WORKDIR
COPY --chown=node . $WORKDIR
# In production environment uncomment the next line
#RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR
# Then all further actions including running the containers should be done under non-root user.
USER $USER
EXPOSE 4000
