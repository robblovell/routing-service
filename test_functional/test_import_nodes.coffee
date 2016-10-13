should = require('should')
assert = require('assert')

async = require('async')

Neo4jRepostitory = require('../source/repositories/Neo4jRepository')
fs = require('fs');
Papa = require('babyparse')
config = require('../config/configuration')

repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepostitory(repoConfig)

describe 'Import Nodes', () ->

    runtest = (importConfig, callback) ->
        console.log("import"+importConfig.nodetype)
        importer = require(importConfig.importer)
        importer.import(importConfig.source, repo, (error, results) ->
            if (error?)
                console.log(error)
                assert(false)
                callback(error, result);
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
                callback(error, result)
                return
            )
            return
        )
        return

    it 'Imports satellites to Neo4j', (callback) ->
        importer = {
            importer: '../source/nodes/importSatellites'
#            source: '../data/Satellites.csv'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/Satellite.csv'  # todo: rename to Satellites
            spotid: '2212'
            nodetype: 'Satellite'
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'Imports products to Neo4j', (callback) ->
        importConfig = {
            importer: '../source/nodes/importProducts'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/Products.csv'
            spotid: '10081215'
            nodetype: 'Product'
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'Imports warehouses to Neo4j', (callback) ->
        importer = {
            importer: '../source/nodes/importWarehouses'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/BDWP.csv' # todo: rename to Warehouses.
            spotid: '2000507'
            nodetype: 'Warehouse'
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'Imports sellers to Neo4j', (callback) ->
        importer = {
            importer: '../source/nodes/importSellers'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/Seller.csv' # todo: rename to Sellers
            spotid: '2000061'
            nodetype: 'Seller'
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'Imports zones to Neo4j', (callback) ->
        importer = {
            importer: '../source/nodes/importZones'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/RadiusZips.csv'  # todo: rename to Zones
            spotid: '15'
            nodetype: 'Zone'
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'Imports global zone to Neo4j', (callback) ->
        importer = {
            importer: '../source/nodes/importGlobalZones'
            source: null
            spotid: '99999'
            nodetype: 'Zone'
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return


