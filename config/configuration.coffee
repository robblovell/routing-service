package_json = require('../package.json');

node_env = if process.env.NODE_ENV? then process.env.NODE_ENV.toLowerCase() else 'local'
ports = { local: '3000', test: '3000', dev: '8091', ci: '7091', qa: '6091', pe: '5091', production: '4091' }

if node_env is 'production'
    host = 'routing.builddirect.com'
else
    host = 'routing.'+node_env+'.builddirect.com'

if node_env is 'local'
    config =
        neo4jurl: process.env.NEO4J_URL || "bolt://neo4j:macro7@localhost"
        port: process.env.EXTERNAL_PORT || '3000'
        host: process.env.HOST || 'localhost'
        scheme: process.env.SCHEME || 'http'
        mountPoint: process.env.MOUNT_POINT || 'file://'+__dirname+'/../data/'
#config.mountPoint = process.env.MOUNT_POINT || 'https://s3-us-west-1.amazonaws.com/bd-freightengine/'

else if node_env is 'test'
    config =
        neo4jurl: process.env.NEO4J_URL || "bolt://develop:k3qPB4V2yxPNAivieu3B@sb10.stations.graphenedb.com:24786/db/data/"
#        neo4jurl: process.env.NEO4J_URL || "bolt://freightengine_dev:bOfUDCSGYsmMxfNwIsMC@db-pznqlogzz2dkqiyplaiy.graphenedb.com:24786"
        port: process.env.EXTERNAL_PORT || '3000'
        host: process.env.HOST || 'localhost'
        scheme: process.env.SCHEME || 'http'
        mountPoint: process.env.MOUNT_POINT || 'file://'+__dirname+'/../data/'

else # node_env is not 'local' or 'test'
    config =
        neo4jurl: process.env.NEO4J_URL
        port: process.env.EXTERNAL_PORT || ports[node_env]
        host: process.env.HOST || host
        scheme: process.env.SCHEME || 'https'

    if (node_env is 'dev')
        config.neo4jurl = process.env.NEO4J_URL || "bolt://develop:k3qPB4V2yxPNAivieu3B@sb10.stations.graphenedb.com:24786/db/data/"
        config.mountPoint = process.env.MOUNT_POINT || 'https://s3-us-west-1.amazonaws.com/bd-freightengine/'

    else if (node_env is 'production')
        config.neo4jurl = process.env.NEO4J_URL || "bolt://freightengine:eQWqMGYgjLsBR2MDVQ7U@db-oanzgatxwapdpu22t3kv.graphenedb.com:24780/db/data/"
        config.mountPoint = process.env.MOUNT_POINT || 'https://s3-us-west-1.amazonaws.com/bd-freightengine/'


    if !config.neo4jurl?
        console.log("no neo4j database connection string specified.")
        process.stop(1)

config.env = node_env
config.internal_port = process.env.PORT || ports[node_env]
config.basepath = "/"
config.version = package_json.version
config.timeout = process.env.TIMEOUT || 15000
config.host_url = config.host+':'+config.port

console.log("configuration: "+JSON.stringify(config))

module.exports = config
