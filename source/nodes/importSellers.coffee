Importer = require('./../importers/ImportFromCSV')

module.exports = (config) ->

    config.cypher = "CREATE (:Seller {
id:line.WarehouseId,
warehouseId:line.WarehouseId,
pimcoreId:line.PIMCoreWarehouseID,
postalCode:line.PostalCode,
name:line.Name,
isSwept:line.isSwept,
sweepToWarehouseId:line.BDWPLocationID})"

    return new Importer(config)