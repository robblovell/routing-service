mongoose = require('mongoose')
Resource = require('resourcejs')
async = require('async')
config = require('../config/configuration')
Neo4jRepostitory = require('../source/repositories/Neo4jRepository')
repoConfig = {url: config.neo4jurl}
combyne = require('combyne')

repo = new Neo4jRepostitory(repoConfig)
edgeMap={
    ProductsToSellers: 'ProductsBelongsToSellers'
    ProductsToWarehouses: 'ProductsBelongsToWarehouses'
    ResupplyToWarehouses: 'ResuppliersResuppliesWarehouses'
    SatelliteToRegions: 'SatellitesLastMileRegions'
    SipsToSatellites: 'SellersSipsToSatellites'
    SipsToWarehouses: 'SellersSipsToWarehouses'
    SweepsTo: 'SellersSweptToWarehouses'
    SellerToRegions: 'SellersLastMileRegions'
    WarehousesToSatelliteLanes: 'WarehousesFlowsThroughSatellites'
    WarehouseToRegions: 'WarehousesLastMileRegions'
}

module.exports = (app, model, config) ->
    resource = Resource(app, '', 'Imports', model)
#    .get()
    .post({
        before: (req, res, next) ->
            importConfig = req.body
            if !importConfig.mount?
                importConfig.mount = config.mountPoint

            if !importConfig.date?
                console.log("No date given")

            if edgeMap[importConfig.name]?
                importConfig.importer = '../source/edges/wireup' + edgeMap[importConfig.name]
            else if importConfig.name.includes('To')
                importConfig.importer = '../source/edges/wireup'+importConfig.name
            else
                importConfig.importer = '../source/nodes/import'+importConfig.name

            if importConfig.mount.includes('://')
                importConfig.source = importConfig.mount+importConfig.template
                if(!importConfig.date?)
                    importConfig.date = ''
                importConfig.source = combyne(importConfig.source).render({ date: importConfig.date}) + '.csv'

            if importConfig.source.includes ('{{') and (!importConfig.date? or !importConfig.count?)
                console.log("A date and count field must be given if a template is used")

            importConfig.repo = repo

            console.log("ImportConfig.importer: " + importConfig.importer)
            console.log("ImporterConfig.source: " + importConfig.source)

            importer = require(importConfig.importer)(importConfig)
            importer.import(importConfig.source, (error, result) ->
                if error?
                    res.send {error: error, code: 400}
                else
                    res.send JSON.stringify(result)

                return
            )
            return
    })

    return resource
