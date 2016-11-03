should = require('should')
assert = require('assert')

async = require('async')

Neo4jRepostitory = require('../../source/repositories/Neo4jRepository')
fs = require('fs');
Papa = require('babyparse')
config = require('../../config/configuration')

repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepostitory(repoConfig)
sourceFilenames = {
    ProductsToSellers: 'sku-seller.csv'
    ProductsToWarehouses: 'sku-bdwp.csv'
#    ResuppliersToWarehouses: 'superdc-bdwp.csv'
#    SatellitesToRegions: null
#    SellersToSatellites: null
#    SellersToWarehouses: 'seller-bdwp.csv'
#    SellersToRegions: null
#    WarehousesToSatellites: 'satellite-bdwp.csv'
#    WarehousesToRegions: null
}
sourceMount = process.env.MOUNT_POINT ? 'file:///'
#sourceMount = 'https://s3-us-west-1.amazonaws.com/bd-ne04j/'
importMount = '../source/edges/wireup'
describe 'Import Relationships', () ->

    it 'wires up edges', (callback) ->
        tests = []

        makeEdgeImport = (name, importer, source) ->
            return (callback) ->
                console.log("import edge  : " + name)
                console.log("import source: "+source)
                importer = require(importer)
                importer.import(source, repo, (error, results) ->
                    if (error?)
                        console.log(error)
                        assert(false)

                    callback(error, results)
                    return
                )
                return

        for name, source of sourceFilenames
            tests.push(makeEdgeImport(name, importMount+name, sourceMount+source))

        async.series(tests, (error, result) ->
            if (error?)
                console.log("error:"+error)
                assert(false)
            else
                assert(true)
        )

