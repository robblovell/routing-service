FROM node:6.7.0
# local
ARG NODE_ENV
# localhost
ARG HOST
# http
ARG SCHEME
# "mongodb://localhost:27017"
ARG DB
# "bolt://neo4j:macro7@localhost"
ARG NEO4J_URL

# expose arguments to the program
ENV NODE_ENV $NODE_ENV
ENV PORT 3000
ENV HOST $HOST
ENV SCHEME $SCHEME
ENV DB $DB
ENV NEO4J_URL $NEO4J_URL

# expose the given port
EXPOSE 3000
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install
RUN npm install gulp -g
RUN npm install coffee-script -g

COPY . /usr/src/app
RUN gulp build

CMD [ "npm", "start" ]