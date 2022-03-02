FROM node:16 as installer
COPY *.* nodegoat/
RUN ls -la nodegoat/
WORKDIR nodegoat/
RUN npm install --production --no-cache
RUN npx contrast-transpile ./server.js

FROM node:16-alpine
WORKDIR /nodegoat
USER = node
RUN chown $USER:$USER $WORKDIR
COPY --chown=node . $WORKDIR
# In production environment uncomment the next line
#RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR
# Then all further actions including running the containers should be done under non-root user.
USER $USER
EXPOSE 4000
CMD ["npm", "start"]
