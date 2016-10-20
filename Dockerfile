FROM alpine
RUN apk update && apk upgrade
RUN apk add nodejs git
RUN npm install gulp coffee-script -g

WORKDIR /app
COPY package.json /app
RUN npm install

COPY . /app
RUN gulp build

# local
ARG NODE_ENV
# localhost
ARG HOST
# http
ARG SCHEME
# "bolt://neo4j:macro7@localhost"
ARG NEO4J_URL

# expose arguments to the program
ENV NODE_ENV $NODE_ENV
ENV NEO4J_URL $NEO4J_URL

# optional environment variables:
ENV PORT $PORT
ENV HOST $HOST
ENV SCHEME $SCHEME

EXPOSE 3000
CMD [ "npm", "start" ]
