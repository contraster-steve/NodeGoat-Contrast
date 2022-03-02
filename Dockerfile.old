FROM node:16 as installer
COPY . /nodegoat
WORKDIR /nodegoat
RUN ls -la 
RUN npm install --production --no-cache

FROM node:16-alpine
WORKDIR /nodegoat
ENV USER node
COPY --chown=node:node . /nodegoat
# In production environment uncomment the next line
#RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR
# Then all further actions including running the containers should be done under non-root user.
USER node
EXPOSE 4000
CMD ["npm", "start"]
