should = require('should')
assert = require('assert')

async = require('async')

Neo4jRepostitory = require('../source/repositories/Neo4jRepository')
fs = require('fs');
Papa = require('babyparse')
config = require('../config/configuration')

repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepostitory(repoConfig)

sourceMount = process.env.MOUNT_POINT ? 'file://'+__dirname+'/../data/'
#sourceMount = 'https://s3-us-west-1.amazonaws.com/bd-ne04j/'

sourceFilenames = {
#    Products: [sourceMount+ 'Products_1007_01.csv', sourceMount+ 'sku_upload_1007_02.csv', sourceMount+ 'sku_upload_1007_03.csv']
    Products: { count: 2, date: "20161007", template:sourceMount+ 'Products_{{date}}_{{number}}.csv'  }
#    Satellites: { count: 3, date: "20161007" }
#    Warehouses: { count: 3, date: "20161007" }
#    Sellers: { count: 3, date: "20161007" }
#    Regions: { count: 3, date: "20161007" }
    Satellites: sourceMount+ 'Satellites.csv'
    Warehouses: sourceMount+ 'Warehouses.csv' # 'BDWP.csv'
    Sellers: sourceMount+ 'Sellers.csv'
    Regions: sourceMount + 'Regions.csv'
}

describe 'Import Nodes', () ->

    runtest = (importConfig, callback) ->
        console.log("import"+importConfig.nodetype)

        importer = require(importConfig.importer)(importConfig)

        importer.import(importConfig.source, (error, results) ->
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

    it 'Imports products to Neo4j', (callback) ->
        importConfig = {
            importer: '../source/nodes/importProducts'
            source: sourceFilenames['Products']
            spotid: '15000404'
            nodetype: 'Product'
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'Imports satellites to Neo4j', (callback) ->
        importConfig = {
            importer: '../source/nodes/importSatellites'
            source: sourceFilenames['Satellites']
            spotid: '2212'
            nodetype: 'Satellite'
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'Imports warehouses to Neo4j', (callback) ->
        importConfig = {
            importer: '../source/nodes/importWarehouses'
            source: sourceFilenames['Warehouses']
            spotid: '2000507'
            nodetype: 'Warehouse'
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'Imports sellers to Neo4j', (callback) ->
        importConfig = {
            importer: '../source/nodes/importSellers'
            source: sourceFilenames['Sellers']
            spotid: '2000061'
            nodetype: 'Seller'
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'Imports regions to Neo4j', (callback) ->
        importConfig = {
            importer: '../source/nodes/importRegions'
            source: sourceFilenames['Regions']
            spotid: '15'
            nodetype: 'Region'
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
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


