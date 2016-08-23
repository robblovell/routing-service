Importer = require('./importers/ImportFromCSV')

config = {
    cypher: "MATCH (s:Product {id:line.ProductItemId}),(b:Warehouse {id:line.WarehouseID})
CREATE (s)-[:BELONGS_TO{
sourceId:line.SourceNodeID,
inventory:line.ProductAvailability,
visibility:1,
id:s.id+'_'+b.id
}]->(b)"
}
importer = new Importer(config)

module.exports = importer