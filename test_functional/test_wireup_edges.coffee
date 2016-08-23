should = require('should')
assert = require('assert')

async = require('async')

Neo4jRepostitory = require('../source/repositories/Neo4jRepository')
fs = require('fs');
Papa = require('babyparse')
config = require('../config/configuration')

repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepostitory(repoConfig)

describe 'Import Relationships', () ->
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

    it 'wireup Product To Sellers', (callback) ->
        importer = {
            importer: '../source/wireupProductToSellers'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/sku-seller.csv'  # todo: rename to product-sellers
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Product To Warehouses', (callback) ->
        importer = {
            importer: '../source/wireupProductToWarehouses'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/sku-bdwp.csv' # todo: rename to product-warehouses
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Resupplier To Warehouses', (callback) ->
        importer = {
            importer: '../source/wireupResupplierToWarehouses'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/superdc-bdwp.csv' # todo: rename to resupplier-warehouses.
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Seller To Warehouses', (callback) ->
        importer = {
            importer: '../source/wireupSellerToWarehouses'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/seller-bdwp.csv' # todo: rename to seller-warehouses
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Warehouse To Satellites', (callback) ->
        importer = {
            importer: '../source/wireupWarehouseToSatellites'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/satellite-bdwp.csv'  # todo: warehouse-satelleites
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Warehouse To Zones', (callback) ->
        importer = {
            importer: '../source/wireupWarehouseToZones'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/Node-ZipRadius.csv'  # todo: warehouse-zones
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Sellers To GlobalZone', (callback) ->
        importer = {
            importer: '../source/wireupSellersToGlobalZone'
            source: null
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Warehouses To GlobalZone', (callback) ->
        importer = {
            importer: '../source/wireupWarehousesToGlobalZone'
            source: null
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return