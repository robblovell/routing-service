mongoose = require('mongoose')
Resource = require('resourcejs')
async = require('async')
config = require('../config/configuration')
Neo4jRepostitory = require('../source/repositories/Neo4jRepository')

repo = new Neo4jRepostitory(repoConfig)
edgeMap={
    SellerInventory: 'ProductsToSellers'
    WarehouseInventory: 'ProductsToWarehouses'
    ResupplyLanes: 'ResuppliersToWarehouses'
    SatelliteRegions: 'SatellitesToRegions'
    Sips: 'SellersToSatellites'
    Sweeps: 'SellersToWarehouses'
    SellerRegions: 'SellersToRegions'
    SatelliteLanes: 'WarehousesToSatellites'
    WarehouseRegions: 'WarehousesToRegions'
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

            if importConfig.name.includes('To')
                importConfig.importer = '../source/import'+importConfig.name
            else if edgeMap[importConfig.name]?
                importConfig.importer = '../source/wireup'+edgemap[importConfig.name]
            else
                importConfig.importer = '../source/wireup'+importConfig.name

            if !importConfig.source?
                importConfig.source = importConfig.mount+'/'+importConfig.name+'_{{date}}_{{number}}'

            ## if a template is given and doesn't contains file:// or https:// add the mount point:
            else if !importConfig.source.includes('://')
                importConfig.source = importConfig.mount+'/'+importConf.template

            if importConfig.source.includes ('{{') and (!importConfig.date? or !importConfig.count?)
                console.log("A date and count field must be given if a template is used")

            importConfig.repo = repo
            console.log("import" + importConfig.importer)
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
