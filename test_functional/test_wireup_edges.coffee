should = require('should')
assert = require('assert')

async = require('async')

Neo4jRepostitory = require('../source/repositories/Neo4jRepository')
fs = require('fs');
Papa = require('babyparse')
config = require('../config/configuration')

repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepostitory(repoConfig)
sourceFilenames = {
    ProductsToSellers: 'sku-seller.csv'
#    ProductsToWarehouses: 'sku-bdwp.csv'
#    ResuppliersToWarehouses: 'superdc-bdwp.csv'
#    SatellitesToZones: null
#    SellersToSatellites: null
#    SellersToWarehouses: 'seller-bdwp.csv'
#    SellersToZones: null
#    WarehousesToSatellites: 'satellite-bdwp.csv'
#    WarehousesToZones: null
}
sourceMount = process.env.MOUNT_POINT ? 'file:///'
sourceMount = 'https://s3-us-west-1.amazonaws.com/bd-ne04j/'

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

    it 'wireup Products To Sellers', (callback) ->
        importer = {
            importer: '../source/edges/wireupProductsToSellers'
            source: sourceMount+ sourceFilenames['ProductsToSellers']
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Products To Warehouses', (callback) ->
        importer = {
            importer: '../source/edges/wireupProductsToWarehouses'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/sku-bdwp.csv' # todo: rename to product-warehouses
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Resuppliers To Warehouses', (callback) ->
        importer = {
            importer: '../source/edges/wireupResuppliersToWarehouses'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/superdc-bdwp.csv' # todo: rename to resupplier-warehouses.
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
#    it 'wireup Satellites To Zones', (callback) ->
#        importer = {
#            importer: '../source/edges/wireupSatellitesToZones'
#            source: null
#        }
#        runtest(importer, (error, result) ->
#            callback(error, result)
#            return
#        )
#        return
#    it 'wireup Sellers To Satellites', (callback) ->
#        importer = {
#            importer: '../source/edges/wireupSellersToSatellites'
#            source: null
#        }
#        runtest(importer, (error, result) ->
#            callback(error, result)
#            return
#        )
#        return
#
    it 'wireup Sellers To Warehouses', (callback) ->
        importer = {
            importer: '../source/edges/wireupSellersToWarehouses'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/seller-bdwp.csv' # todo: rename to seller-warehouses
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'wireup Sellers To Zones', (callback) ->
        importer = {
            importer: '../source/edges/wireupSellersToZones'
            source: null
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'wireup Warehouses To Satellites', (callback) ->
        importer = {
            importer: '../source/edges/wireupWarehousesToSatellites'
            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/satellite-bdwp.csv'  # todo: warehouse-satelleites
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'wireup Warehouses To Zones', (callback) ->
        importer = {
            importer: '../source/edges/wireupWarehousesToZones'
            source: null
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return