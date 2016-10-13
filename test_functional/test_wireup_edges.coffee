should = require('should')
assert = require('assert')

async = require('async')

Neo4jRepostitory = require('../source/repositories/Neo4jRepository')
fs = require('fs');
Papa = require('babyparse')
config = require('../config/configuration')

repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepostitory(repoConfig)

sourceMount = process.env.MOUNT_POINT ? 'file://'+__dirname+'/data/'

#sourceMount = 'https://s3-us-west-1.amazonaws.com/bd-ne04j/'

sourceFilenames = {
    ProductsToSellers: sourceMount+'ProductsToSellers.csv' # 'sku-seller.csv'
    ProductsToWarehouses: sourceMount+'ProductsToWarehouses.csv' # 'sku-bdwp.csv'
    ResuppliersToWarehouses: sourceMount+'ResuppliersToWarehouses.csv' # 'superdc-bdwp.csv'
    SatellitesToZones: sourceMount+'SatellitesToZones.csv' # 'Node-ZipRadius.csv'
    SellersToSatellites: null
    SellersToWarehouses: sourceMount+'SellersToWarehouses.csv' # 'seller-bdwp.csv'
    SellersToZones: null # just to the global zone
    WarehousesToSatellites: sourceMount+'WarehousesToSatellites.csv' # 'satellite-bdwp.csv'
    WarehousesToZones: null # just to the global zone.
}

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
            source: sourceFilenames['ProductsToSellers']
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Products To Warehouses', (callback) ->
        importer = {
            importer: '../source/edges/wireupProductsToWarehouses'
            source: sourceFilenames['ProductsToWarehouses']

#            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/sku-bdwp.csv' # todo: rename to product-warehouses
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Resuppliers To Warehouses', (callback) ->
        importer = {
            importer: '../source/edges/wireupResuppliersToWarehouses'

            source: sourceFilenames['ResuppliersToWarehouses']

#            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/superdc-bdwp.csv' # todo: rename to resupplier-warehouses.
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Satellites To Zones', (callback) ->
        importer = {
            importer: '../source/edges/wireupSatellitesToZones'
            source: sourceFilenames['SatellitesToZones']

#            source: null
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return
# sips
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
            source: sourceFilenames['SellersToWarehouses']

#            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/seller-bdwp.csv' # todo: rename to seller-warehouses
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
            source: sourceFilenames['WarehousesToSatellites']

#            source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/satellite-bdwp.csv'  # todo: warehouse-satelleites
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'wireup Warehouses To Zones', (callback) ->
        importer = {
            importer: '../source/edges/wireupWarehousesToZones'
            source: sourceFilenames['WarehousesToZones']
        }
        runtest(importer, (error, result) ->
            callback(error, result)
            return
        )
        return