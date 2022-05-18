# NodeGoat with Contrast
Being lightweight, fast, and scalable, Node.js is becoming a widely adopted platform for developing web applications. This project provides an environment to learn how OWASP Top 10 security risks apply to web applications developed using Node.js and how to effectively address them.

## WARNING!
THIS WEB APPLICATION CONTAINS NUMEROUS SECURITY VULNERABILITIES WHICH WILL RENDER YOUR COMPUTER VERY INSECURE WHILE RUNNING! IT IS HIGHLY RECOMMENDED TO COMPLETELY DISCONNECT YOUR COMPUTER FROM ALL NETWORKS WHILE RUNNING!

## Google Chrome Note
Google Chrome performs filtering for reflected XSS attacks. These attacks will not work unless chrome is run with the argument `--disable-xss-auditor`.

### Contrast Instrumentation 
This repo includes the components necessary to instrument contrast Assess/Protect with this Node.js application except for the contrast_security.yaml file containing the connection strings.

Specifically modified:

1. package.json includes @contrast/agent as a dependency (note: you might want to upgrade the version to the latest) and "start": "node -r @contrast/agent server.js -c /app/nodegoat/contrast_security.yaml".
2. The docker-compose.yml includes the path to the contrast_security.yaml (not included), enables the Node rewrite cache, and sets a few other specific environment variables.
3. Three other docker-compose YAMLs depending on what "environment" you're wanting to run: Development, QA, or Production.

contrast_security.yaml example:

api:<br>
&nbsp;&nbsp;url: https://apptwo.contrastsecurity.com/Contrast<br>
&nbsp;&nbsp;api_key: [REDACTED<br>
&nbsp;&nbsp;service_key: [REDACTED]<br>
&nbsp;&nbsp;user_name: [REDACTED]<br>
application:<br>
&nbsp;&nbsp;session_metadata: buildNumber=${BUILD_NUMBER}, committer=Steve Smith #buildNumber is inserted via Jenkins Pipeline<br>

Your contrast_security.yaml file needs to be in the root of the web application directory. It then gets copied into the Docker Container.

# Requirements

1. Docker Community Edition
2. docker-compose

When built, the Dockerfile pulls in all of the source code and builds the dotnet Core application. 

## How to build and run

### 1. Running in a Docker Container

The provided Dockerfile is compatible with both Linux and Windows containers (note from Steve: I've only run it on Linux).

To build a Docker image, execute the following command: docker-compose build

### Linux Containers

To run the `nodegoat` Container image, execute one of the following commands:

1. Development: docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

2. QA: docker-compose -f docker-compose.yml -f docker-compose.qa.yml up -d

3. Production (this disables Assess and enables Protect): docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

Nodegoat should be accessible at http://ip_address:4000.


### Stopping the Docker container

To stop the `nodegoat` container, execute the following command in the same directory as your docker-compose files: docker-compose stop 

### 2. Building with Jenkins
Included is a sample Jenkinsfile that can be used as a Jenkins Pipeline to build and run the application. The Jenkins Pipeline passes buildNumber as a parameter to the YAML. 

#### Default user accounts
The database comes pre-populated with these user accounts created as part of the seed data -
* Admin Account - u:admin p:Admin_123
* User Accounts (u:user1 p:User1_123), (u:user2 p:User2_123)
* New users can also be added using the sign-up page.








