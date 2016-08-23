should = require('should')
assert = require('assert')

async = require('async')

Neo4jRepostitory = require('../../source/repositories/Neo4jRepository')
fs = require('fs');
Papa = require('babyparse')
config = require('../../config/configuration')

repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepostitory(repoConfig)

describe 'Import Relationship Warehouses To GlobalZone', () ->
    runtest = (testImport, callback) ->
        console.log("import" + testImport.importer)
        importer = require(testImport.importer)
        importer.import(testImport.source, repo, (error, results) ->
            if (error?)
                console.log(error)
                assert(false)

            callback(error, results)
            return
        )
        return

    it 'wireup Warehouses To GlobalZone', (callback) ->
        importer = {
            importer: '../../source/wireupWarehousesToGlobalZone'
            source: null
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return