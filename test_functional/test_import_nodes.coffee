should = require('should')
assert = require('assert')

async = require('async')

Neo4jRepostitory = require('../source/repositories/Neo4jRepository')
fs = require('fs');
Papa = require('babyparse')
config = require('../config/configuration')

repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepostitory(repoConfig)

sourceMount = config.mountPoint

sourceFilenames = {
    Satellites: sourceMount+ 'Satellites_20161020.csv'
    Warehouses: sourceMount+ 'Warehouses_20161020.csv' # 'BDWP.csv'
    Sellers: sourceMount+ 'Sellers_20161020.csv'
    Products: sourceMount+ 'Products_20161020.csv'
#    Products: { count: 22, date: "20161020", template:sourceMount+ 'Products_{{date}}.csv_{{characters}}', characters: true }
    Regions: sourceMount + 'Regions_20161020.csv'
#    Regions: { count: 57, date: "20161020", template:sourceMount+ 'Regions_{{date}}.csv_{{characters}}', characters: true }
}

describe 'Import Nodes', () ->
    @timeout(10*60*1000) # 10 minutes

    runtest = (importConfig, done) ->
        console.log("import"+importConfig.nodetype)

        importer = require(importConfig.importer)(importConfig)

        importer.import(importConfig.source, (error, results) ->
            if (error?)
                console.log(error)
                assert(false)
                done(error, result);
                return
            # do a spot check:
            repo.get({id: importConfig.spotid, type: importConfig.nodetype}, (error, result) ->
                if (error?)
                    assert(false)
                    callback(error, result);
                    return
                data = result[0]
                data.id.should.be.equal(importConfig.spotid)
                console.log("completed: "+importConfig.nodetype)
                done(error, result)
                return
            )
            return
        )
        return

    it 'Imports satellites to Neo4j', (done) ->
        importConfig = {
            importer: '../source/nodes/importSatellites'
            source: sourceFilenames['Satellites']
            spotid: '2212'
            nodetype: 'Satellite'
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            done(error, result)
            return
        )
        return

    it 'Imports warehouses to Neo4j', (done) ->
        importConfig = {
            importer: '../source/nodes/importWarehouses'
            source: sourceFilenames['Warehouses']
            spotid: '69392'
            nodetype: 'Warehouse'
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            done(error, result)
            return
        )
        return

    it 'Imports sellers to Neo4j', (done) ->
        importConfig = {
            importer: '../source/nodes/importSellers'
            source: sourceFilenames['Sellers']
            spotid: '70554'
            nodetype: 'Seller'
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            done(error, result)
            return
        )
        return

    it 'Imports regions to Neo4j', (done) ->
        importConfig = {
            importer: '../source/nodes/importRegions'
            source: sourceFilenames['Regions']
            spotid: '15'
            nodetype: 'Region'
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            done(error, result)
            return
        )
        return

    it 'Imports products to Neo4j', (done) ->
        @timeout(300000)

        importConfig = {
            importer: '../source/nodes/importProducts'
            source: sourceFilenames['Products']
            spotid: '15000404'
            nodetype: 'Product'
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            done(error, result)
            return
        )
        return

#
#    it 'Imports global region to Neo4j', (callback) ->
#        importer = {
#            importer: '../source/nodes/importGlobalRegions'
#            source: null
#            spotid: '99999'
#            nodetype: 'Region'
#        }
#        runtest(importer, (error, result) ->
#            callback(error, result)
#            return
#        )
#        return


