Importer = require('./../importers/ImportFromCSV')

config = {
    cypher: "CREATE (:Seller {
id:line.WarehouseId,
warehouseId:line.WarehouseId,
pimcoreId:line.PIMCoreWarehouseID,
postalCode:line.PostalCode,
name:line.Name,
isSwept:line.isSwept,
sweepToWarehouseId:line.BDWPLocationID})"
}
importer = new Importer(config)

module.exports = importer
