FROM node:16-alpine as installer
COPY . /app/nodegoat
WORKDIR /app/nodegoat
RUN ls -la
RUN npm install --production --no-cache && npm install @contrast/agent --no-optional

FROM node:16-alpine
WORKDIR /app/nodegoat
RUN addgroup --system --gid 1001 nodegoat && \
    adduser nodegoat --system --uid 1001 --ingroup nodegoat
COPY --from=installer --chown=nodegoat /app/nodegoat .

# In production environment uncomment the next line
#RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR
# Then all further actions including running the containers should be done under non-root user.
USER nodegoat

RUN chmod +x ./startup.sh
EXPOSE 4000
CMD ["npm", "start"]
