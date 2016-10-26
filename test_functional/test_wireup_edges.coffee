should = require('should')
assert = require('assert')

async = require('async')

Neo4jRepostitory = require('../source/repositories/Neo4jRepository')
fs = require('fs');
Papa = require('babyparse')
config = require('../config/configuration')

repoConfig = {url: config.neo4jurl}

sourceMount = config.mountPoint

sourceFilenames = {
    ResuppliersResuppliesWarehouses: sourceMount+'ResuppliersResuppliesWarehouses_20161020.csv' # 'superdc-bdwp.csv'
    SatellitesLastMileRegions: sourceMount+'SatellitesLastMileRegions_20161020.csv' # 'Node-ZipRadius.csv'
    SellersSweptToWarehouses: sourceMount+'SellersSweptToWarehouses_20161020.csv' # 'seller-bdwp.csv'
    SellersSipsToWarehouses: sourceMount+'SellersSipsToWarehouses_20161020.csv' # 'seller-bdwp.csv'
    SellersLastMileRegions: null # just to the global region
    WarehousesFlowsThroughSatellites: sourceMount+'WarehousesFlowsThroughSatellites_20161020.csv' # 'satellite-bdwp.csv'
    WarehousesLastMileRegions: null # just to the global region.
    ProductsBelongsToWarehouses: sourceMount+'ProductsBelongsToWarehouses_20161020.csv' # 'sku-bdwp.csv'
#    ProductsBelongsToSellers: sourceMount+'ProductsBelongsToSellers_20161020.csv' # 'sku-seller.csv'
    ProductsBelongsToSellers: { count: 27, date: "20161020", template:sourceMount+ 'ProductsBelongsToSellers_{{date}}.csv_{{characters}}', characters: true }

}

describe 'Import Relationships', () ->
    @timeout(40*60*1000) # 40 minutes

    runtest = (importConfig, callback) ->
        console.log("importer used: " + importConfig.importer)
        console.log("from file: " + importConfig.source)

        _importer = require(importConfig.importer)(importConfig)
        _importer.import(importConfig.source, (error, results) ->
            if (error?)
                console.log(error)
                assert(false)

            callback(error, results)
            return
        )
        return
#
#    makeTest = (importConfig) ->
#        return (callback) ->
#            runtest(importConfig, (error, result) ->
#                callback(error, result)
#                return
#            )
#    it 'wires up edges', (done) ->
#        wireups = []
#        for importername,filename of sourceFilenames
#            importConfig = {
#                importer: '../source/edges/wireup'+importername
#                source: filename
#                repo: repo
#            }
#            wireups.push (makeTest(importConfig))
#
#        async.series(wireups, (error, result) ->
#            assert(false) if error?
#            done() if result?
#            return
#        )
#        return

    it 'wireup Resuppliers Resupplies Warehouses', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupResuppliersResuppliesWarehouses'
            source: sourceFilenames['ResuppliersResuppliesWarehouses']
            repo: new Neo4jRepostitory(repoConfig)
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'wireup Satellites Last Mile Regions', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupSatellitesLastMileRegions'
            source: sourceFilenames['SatellitesLastMileRegions']
            repo: new Neo4jRepostitory(repoConfig)
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return
## sips
    it 'wireup Sellers Sips To Warehouses', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupSellersSipsToWarehouses'
            source: sourceFilenames['SellersSipsToWarehouses']
            repo: new Neo4jRepostitory(repoConfig)
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return
## sweeps
    it 'wireup Sellers Swept To Warehouses', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupSellersSweptToWarehouses'
            source: sourceFilenames['SellersSweptToWarehouses']
            repo: new Neo4jRepostitory(repoConfig)
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return
# Last Mile (Seller)
    it 'wireup Sellers Last Mile Regions', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupSellersLastMileRegions'
            source: null
            repo: new Neo4jRepostitory(repoConfig)
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return
#
    it 'wireup Warehouses Flows Through Satellites', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupWarehousesFlowsThroughSatellites'
            source: sourceFilenames['WarehousesFlowsThroughSatellites']
            repo: new Neo4jRepostitory(repoConfig)
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return
#
    it 'wireup Warehouses Last Mile Regions', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupWarehousesLastMileRegions'
            source: null
            repo: new Neo4jRepostitory(repoConfig)
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'wireup Products Belongs To Sellers', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupProductsBelongsToSellers'
            source: sourceFilenames['ProductsBelongsToSellers']
            repo: new Neo4jRepostitory(repoConfig)
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'wireup Products Belongs To Warehouses', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupProductsBelongsToWarehouses'
            source: sourceFilenames['ProductsBelongsToWarehouses']
            repo: new Neo4jRepostitory(repoConfig)
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return