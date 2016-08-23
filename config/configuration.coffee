config =
    env: process.env.NODE_ENV || 'local'
    db: process.env.DB || "mongodb://localhost:27017"
    neo4jurl: process.env.NEO4J_URL || "bolt://neo4j:macro7@localhost"
    port: process.env.PORT || '3000'
    host: process.env.HOST || 'localhost'
    basepath: "/"
    scheme: process.env.SCHEME || 'http'
    insightsKey: ""
    segementKey: ""
    version: "0.0.1"
    timeout: 15000

switch config.env
# todo:: develop and staging databases
    when 'develop'
        config.db = process.env.DB
        config.host = process.env.HOST
    when 'staging'
        config.db = process.env.DB
        config.host = process.env.HOST
    when 'production'
        config.db = process.env.DB
        config.host = process.env.HOST
    else
        config.db = "mongodb://localhost:27017/network" #"mongodb://localhost:27017"
        config.host = "localhost:3000"
        config.schemes = ['http']

console.log("configuration: "+JSON.stringify(config))
module.exports = config
