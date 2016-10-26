should = require('should')
assert = require('assert')

describe 'Test Read Header', () ->

    require_config = () ->
        for key,value of require.cache
            if (key.includes('configuration'))
                delete(require.cache[key])
        return require('../config/configuration')

    it 'reads local configuration environment', (done) ->
        process.env.NODE_ENV = 'local'
        config = require_config()
        JSON.stringify(config).should.be.equal('{"neo4jurl":"bolt://neo4j:macro7@localhost",\
"port":"3000","host":"localhost","scheme":"http",\
"mountPoint":"'+'file://'+__dirname.replace("test","config")+'/../data/"'+',\
"env":"local","internal_port":"3000","basepath":"/","version":"0.1.2","timeout":15000,\
"host_url":"localhost:3000"}')
        done()
        return

    it 'reads dev configuration environment', (done) ->
        process.env.NODE_ENV = 'dev'
        config = require_config()

        JSON.stringify(config).should.be.equal('\
{"neo4jurl":"bolt://develop:k3qPB4V2yxPNAivieu3B@sb10.stations.graphenedb.com:24786/db/data/",\
"port":"8091","host":"routingservice.dev.builddirect.com","scheme":"https",\
"mountPoint":"https://s3-us-west-1.amazonaws.com/bd-freightengine/",\
"env":"dev","internal_port":"8091","basepath":"/","version":"0.1.2","timeout":15000,\
"host_url":"routingservice.dev.builddirect.com:8091"}')
        done()
        return

    it 'reads production configuration environment', (done) ->
        process.env.NODE_ENV = 'production'
        config = require_config()

        JSON.stringify(config).should.be.equal('\
{"neo4jurl":"bolt://freightengine:eQWqMGYgjLsBR2MDVQ7U@db-oanzgatxwapdpu22t3kv.graphenedb.com:24780/db/data/",\
"port":"4091","host":"routingservice.builddirect.com","scheme":"https",\
"mountPoint":"https://s3-us-west-1.amazonaws.com/bd-freightengine/",\
"env":"production","internal_port":"4091","basepath":"/","version":"0.1.2","timeout":15000,\
"host_url":"routingservice.builddirect.com:4091"}')
        done()
        return

    it 'reads test configuration environment', (done) ->
        process.env.NODE_ENV = 'test'
        config = require_config()

        JSON.stringify(config).should.be.equal('\
{"neo4jurl":"bolt://develop:k3qPB4V2yxPNAivieu3B@sb10.stations.graphenedb.com:24786/db/data/",\
"port":"3000","host":"localhost","scheme":"http",\
"mountPoint":"'+'file://'+__dirname.replace("test","config")+'/../data/"'+',\
"env":"test","internal_port":"3000","basepath":"/","version":"0.1.2","timeout":15000,\
"host_url":"localhost:3000"}')
        done()
        return