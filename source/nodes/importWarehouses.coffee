Importer = require('./../importers/ImportFromCSV')

config = {
    cypher: "CREATE (:Warehouse {
id:line.WarehouseId,
warehouseId:line.WarehouseId,
pimcoreId:line.PIMCoreWarehouseID,
postalCode:line.PostalCode,
name:line.Name,
isSuperDC:line.isSuperDC})"
}
importer = new Importer(config)

module.exports = importer
