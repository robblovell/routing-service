mongoose = require('mongoose')
Resource = require('resourcejs')
async = require('async')
config = require('../config/configuration')

edgeMap={
    SellerInventory: 'ProductsToSellers'
    WarehouseInventory: 'ProductsToWarehouses'
    ResupplyLanes: 'ResuppliersToWarehouses'
    SatelliteZones: 'SatellitesToZones'
    Sips: 'SellersToSatellites'
    Sweeps: 'SellersToWarehouses'
    SellerZones: 'SellersToZones'
    SatelliteLanes: 'WarehousesToSatellites'
    WarehouseZones: 'WarehousesToZones'
}

module.exports = (app, model) ->
    resource = Resource(app, '', 'Imports', model)
#    .get()
    .post({
        before: (req, res, next) ->
            Importer = {
                source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/Satellite.csv'
                name: 'Satellites'
            }

            if Importer.name.includes('To')
                Importer.importer = '../source/import'+Importer.name
            else if edgeMap[Importer.name]?
                Importer.importer = '../source/wireup'+edgemap[Importer.name]
            else
                Importer.importer = '../source/wireup'+Importer.name

            console.log("import" + Importer.importer)
            importer = require(Importer.importer)
            importer.import(Importer.source, repo, (error, results) ->
                if (error?)
                    console.log(error)
                else if (results?)
                    console.log(results)
                return
            )
            return
    })

    return resource
