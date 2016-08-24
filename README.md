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

TODO:

* CLI for imports

