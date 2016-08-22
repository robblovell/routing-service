Importer = require('./importers/ImportNodeFromCSV')

config = {
    cypher: "CREATE (:Warehouse {warehouseId:line.WarehouseId,pimcorewarehouseid:line.PIMCoreWarehouseID,\
postalcode:line.PostalCode,name:line.Name,issuperdc:line.isSuperDC})"
}
importer = new Importer(config)

module.exports = importer
