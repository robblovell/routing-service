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

    runtest = (testImport, callback) ->
        console.log("import"+testImport.nodetype)
        importer = require(testImport.importer)
        importer.import(testImport.source, repo, (error, results) ->
            if (error?)
                console.log(error)
                assert(false)
                callback(error, result);
                return
            # do a spot check:
            repo.get({id: testImport.spotid, type: testImport.nodetype}, (error, result) ->
                if (error?)
                    assert(false)
                    callback(error, result);
                    return
                data = result[0]
                data.id.should.be.equal(testImport.spotid)
                console.log("completed: "+testImport.nodetype)
                callback(error, result)
                return
            )
            return
        )
        return

    it 'Imports satellites to Neo4j', (callback) ->
        importer = {
            importer: '../source/importSatellites'
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
        importer = {
            importer: '../source/importProducts'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/Products.csv'
            spotid: '10081215'
            nodetype: 'Product'
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'Imports warehouses to Neo4j', (callback) ->
        importer = {
            importer: '../source/importWarehouses'
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
            importer: '../source/importSellers'
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
            importer: '../source/importZones'
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
            importer: '../source/importZoneGlobal'
            source: null
            spotid: '99999'
            nodetype: 'Zone'
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return


