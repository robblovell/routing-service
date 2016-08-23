Importer = require('./importers/ImportFromCSV')

config = {
    cypher: "MATCH (b:Warehouse {id:line.BDWPWarehouseID}),(s:Satellite {id:line.SatelliteWarehouseID})
CREATE (b)-[:FLOWS_THROUGH{
sellerCost:line.sellercost,
leadTime:line.leadtime,
bdCost:line.bdcost,
custCost:line.custcost
}]->(s)"
}
importer = new Importer(config)

module.exports = importer