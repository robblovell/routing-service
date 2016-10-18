Importer = require('./../importers/ImportFromCSV')

module.exports = (config) ->

    config.cypher = "CREATE (:Satellite {
    id:line.WarehouseID,
    warehouseid:line.WarehouseID,
    name:line.Name,
    satelliteToWarehouseId:line.BDWPWarehouseID,
    postalcode:line.PostalCode})"

    return new Importer(config)

