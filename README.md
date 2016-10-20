### routing-network-server

A persistence layer for a routing network and mechanisms to determine minimum paths from one node to another.

To setup and test:

```
npm install
npm test
```

To make this work:

Install neo4j locally.  Set the password for the 'neo4j' user to 'macro7'.

```
npm install
gulp build
npm start
```

This will start the rest server.

To run imports from files to build the network (takes about 20 seconds now.:

`npm run import`

The network consists of a warehouse node type where products or "products" can reside: 
**Warehouses (BDWP and SuperDC's), Seller (Sweeps and doesn't sweep), or Satellite for Warehouses**

Docker: to build and run a docker image locally:

docker build -t bd-routingservice .

docker run -it -p 3000:3000 -e NODE_ENV=local --rm --name routingservice bd-routingservice

cleanup: 
docker rm -v $(docker ps -a -q -f status=exited)

docker rmi -v $(docker images)


TODO:

* CLI for imports

