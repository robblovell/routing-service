package_json = require('../package.json');
config =
    env: process.env.NODE_ENV || 'local'
    db: process.env.DB || "mongodb://localhost:27017"
    neo4jurl: process.env.NEO4J_URL || "bolt://neo4j:macro7@localhost"
    port: process.env.PORT || '3000'
    host: process.env.HOST || 'localhost'
    basepath: "/"
    scheme: process.env.SCHEME || 'http'
    version: package_json.version
    timeout: process.env.TIMEOUT || 15000

config.host_url = config.host+':'+config.port

if process.env.NODE_ENV == "test"
    config.db = "mongodb://bd-rulesservice-dev:iJyHMx2TJBxv2GLFXE1WNinuiC3P5IAZRPIMU55Ctd3xeLjBCSSKJtWoi5hDEk5pTM16TcZbDDUiNbnTV1rAFg==@bd-rulesservice-dev.documents.azure.com:10250/?ssl=true"
    config.neo4jurl = "bolt://develop:k3qPB4V2yxPNAivieu3B@sb10.stations.graphenedb.com:24786"

console.log("configuration: "+JSON.stringify(config))
module.exports = config
