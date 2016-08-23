config =
    env: process.env.NODE_ENV || 'local'
    db: process.env.DB || "mongodb://localhost:27017"
    neo4jurl: process.env.NEO4J_URL || "bolt://neo4j:macro7@localhost"
    port: process.env.PORT || '3000'
    host: process.env.HOST || 'localhost:3000'
    basepath: "/"
    scheme: process.env.SCHEME || 'http'
    insightsKey: process.env.INSIGHTS_KEY || ""
    segementKey: process.env.SEGMENT_KEY || ""
    version: "0.0.2"
    timeout: process.env.SEGMENT_KEY || 15000

if config.env != 'develop' and config.env != 'staging' and config.env != 'production'
    config.db = "mongodb://localhost:27017/network" #"mongodb://localhost:27017"
    config.host = "localhost:3000"

console.log("configuration: "+JSON.stringify(config))
module.exports = config
