Importer = require('./../importers/ImportFromCSV')
# todo: test
config = {
    cypher: "MATCH (s:Seller),(s:Satellite {id:line.SatelliteWarehouseID})
CREATE (s)-[:FLOWS_THROUGH{
sellerCost:line.sellercost,
leadTime:line.leadtime,
bdCost:line.bdcost,
custCost:line.custcost,
id:b.id+'_'+s.id
}]->(s)"
}
importer = new Importer(config)

module.exports = importer