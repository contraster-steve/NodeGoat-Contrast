FROM node:12-alpine
ENV WORKDIR /usr/src/app/dev/
WORKDIR $WORKDIR
COPY package*.json $WORKDIR

RUN npm install --production --no-cache & 
RUN npm install -g @contrast/agent &

FROM node:12-alpine
ENV USER node
ENV WORKDIR /home/$USER/app/dev/
WORKDIR $WORKDIR
COPY --from=0 /usr/src/app/dev/node_modules/ node_modules
RUN chown $USER:$USER $WORKDIR
COPY --chown=node . $WORKDIR
# In production environment uncomment the next line
#RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR
# Then all further actions including running the containers should be done under non-root user.
USER $USER
