Importer = require('./importers/ImportFromCSV')

config = {
    cypher: "CREATE (:Satellite {
id:line.WarehouseID,
warehouseid:line.WarehouseID,
name:line.Name,
satelliteToWarehouseId:line.BDWPWarehouseID,
postalcode:line.PostalCode})"
}
importer = new Importer(config)

module.exports = importer
