should = require('should')
assert = require('assert')

describe 'Test Read Header', () ->

    require_config = () ->
        for key,value of require.cache
            if (key.includes('configuration'))
                delete(require.cache[key])
        return require('../config/configuration')

    base_dir = __dirname.replace('test','config')
    console.log(base_dir)
    it 'reads local configuration environment', (done) ->
        process.env.NODE_ENV = 'local'
        config = require_config()
        JSON.stringify(config).should.be.equal('{"neo4jurl":"bolt://neo4j:macro7@localhost","port":"3000","host":"localhost","scheme":"http","mountPoint":"file://'+base_dir+'/../data/","env":"local","internal_port":"3000","basepath":"/","version":"0.1.3","timeout":15000,"host_url":"localhost:3000"}')
        done()
        return

    it 'reads dev configuration environment', (done) ->
        process.env.NODE_ENV = 'dev'
        config = require_config()

        JSON.stringify(config).should.be.equal('{"neo4jurl":"bolt://develop:k3qPB4V2yxPNAivieu3B@sb10.stations.graphenedb.com:24786","port":"8091","host":"routing.dev.builddirect.com","scheme":"http","mountPoint":"https://s3-us-west-1.amazonaws.com/bd-freightengine/","env":"dev","internal_port":"8091","basepath":"/","version":"0.1.3","timeout":15000,"host_url":"routing.dev.builddirect.com:8091"}')
        done()
        return

    it 'reads production configuration environment', (done) ->
        process.env.NODE_ENV = 'production'
        config = require_config()

        JSON.stringify(config).should.be.equal('{"neo4jurl":"bolt://freightengine:eQWqMGYgjLsBR2MDVQ7U@db-oanzgatxwapdpu22t3kv.graphenedb.com:24786","port":"4091","host":"routing.builddirect.com","scheme":"http","mountPoint":"https://s3-us-west-1.amazonaws.com/bd-freightengine/","env":"production","internal_port":"4091","basepath":"/","version":"0.1.3","timeout":15000,"host_url":"routing.builddirect.com:4091"}')
        done()
        return

    it 'reads test configuration environment', (done) ->
        process.env.NODE_ENV = 'test'
        config = require_config()

        JSON.stringify(config).should.be.equal('{"neo4jurl":"bolt://develop:k3qPB4V2yxPNAivieu3B@sb10.stations.graphenedb.com:24786","port":"3000","host":"localhost","scheme":"http","mountPoint":"file://'+base_dir+'/../data/","env":"test","internal_port":"3000","basepath":"/","version":"0.1.3","timeout":15000,"host_url":"localhost:3000"}')
        done()
        return