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
    ProductsToSellers: sourceMount+'ProductsToSellers.csv' # 'sku-seller.csv'
    ProductsToWarehouses: sourceMount+'ProductsToWarehouses.csv' # 'sku-bdwp.csv'
    ResuppliersToWarehouses: sourceMount+'ResuppliersToWarehouses.csv' # 'superdc-bdwp.csv'
    SatellitesToRegions: sourceMount+'SatellitesToRegions.csv' # 'Node-ZipRadius.csv'
    SellersToSatellites: null
    SellersToWarehouses: sourceMount+'SellersToWarehouses.csv' # 'seller-bdwp.csv'
    SellersToRegions: null # just to the global region
    WarehousesToSatellites: sourceMount+'WarehousesToSatellites.csv' # 'satellite-bdwp.csv'
    WarehousesToRegions: null # just to the global region.
}

describe 'Import Relationships', () ->
    runtest = (importConfig, callback) ->
        console.log("import" + importConfig.importer)
        importer = require(importConfig.importer)(importConfig)
        importer.import(importConfig.source, (error, results) ->
            if (error?)
                console.log(error)
                assert(false)

            callback(error, results)
            return
        )
        return

    it 'wireup Products To Sellers', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupProductsToSellers'
            source: sourceFilenames['ProductsToSellers']
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Products To Warehouses', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupProductsToWarehouses'
            source: sourceFilenames['ProductsToWarehouses']
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Resuppliers To Warehouses', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupResuppliersToWarehouses'
            source: sourceFilenames['ResuppliersToWarehouses']
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return
    it 'wireup Satellites To Regions', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupSatellitesToRegions'
            source: sourceFilenames['SatellitesToRegions']
            repo: repo
        }
        runtest(importConfig, (error, result) ->
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
        importConfig = {
            importer: '../source/edges/wireupSellersToWarehouses'
            source: sourceFilenames['SellersToWarehouses']
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'wireup Sellers To Regions', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupSellersToRegions'
            source: null
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'wireup Warehouses To Satellites', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupWarehousesToSatellites'
            source: sourceFilenames['WarehousesToSatellites']
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return

    it 'wireup Warehouses To Regions', (callback) ->
        importConfig = {
            importer: '../source/edges/wireupWarehousesToRegions'
            source: sourceFilenames['WarehousesToRegions']
            repo: repo
        }
        runtest(importConfig, (error, result) ->
            callback(error, result)
            return
        )
        return