Importer = require('./importers/ImportFromCSV')

config = {
    cypher: "MATCH (s:Product {id:line.ProductItemId}),(b:Seller {id:line.WarehouseID})
CREATE (s)-
[:BELONGS_TO{
sourceId:line.SourceNodeID,
inventory:line.ProductAvailability,
visibility:1
}]->(b)"
}
importer = new Importer(config)

module.exports = importer