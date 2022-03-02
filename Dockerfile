FROM node:16-alpine as installer
COPY . /app/nodegoat
WORKDIR /app/nodegoat
RUN npm install --production --no-cache && npm install @contrast/agent --no-optional

FROM node:16-alpine
ENV USER node
ENV WORKDIR /app/nodegoat
RUN ls -la
WORKDIR $WORKDIR
RUN chown $USER:$USER $WORKDIR
COPY --chown=node . $WORKDIR
# In production environment uncomment the next line
#RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR
# Then all further actions including running the containers should be done under non-root user.
USER $USER
EXPOSE 4000
