FROM ubuntu:20.04 as installer
ENV DEBIAN_FRONTEND="noninteractive" TZ="America/Chicago"
RUN apt-get update
RUN apt install curl
RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt install nodejs
RUN apt-get -y install npm 
COPY . /app/nodegoat
WORKDIR /app/nodegoat
RUN ls -la
RUN npm install --production --no-cache && npm install @contrast/agent --no-optional
RUN ls -la /app/nodegoat
RUN cat /app/nodegoat/contrast_security.yaml

FROM ubuntu:20.04
WORKDIR /app/nodegoat
RUN addgroup --system --gid 1001 nodegoat && \
    adduser nodegoat --system --uid 1001 --ingroup nodegoat
COPY --from=installer --chown=nodegoat /app/nodegoat .
RUN chown nodegoat:nodegoat /app/nodegoat/contrast_security.yaml
RUN ls -la /app/nodegoat
# In production environment uncomment the next line
#RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR
# Then all further actions including running the containers should be done under non-root user.
USER nodegoat
RUN chmod +x ./startup.sh
EXPOSE 4000
CMD ["npm", "start"]
