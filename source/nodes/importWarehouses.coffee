Importer = require('./../importers/ImportFromCSV')

module.exports = (config) ->

    config.cypher = "CREATE (:Warehouse {
id:line.WarehouseId,
warehouseId:line.WarehouseId,
pimcoreId:line.PIMCoreWarehouseID,
postalCode:line.PostalCode,
name:line.Name,
isSuperDC:line.isSuperDC})"

    return new Importer(config)