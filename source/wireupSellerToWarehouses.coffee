Importer = require('./importers/ImportFromCSV')

config = {
    cypher: "MATCH (s:Seller {id:line.SellerLocationID}),(b:Warehouse {id:line.BDWPLocationID})
CREATE (s)-[:SWEPT_TO{
sellerCost:line.sellercost,
leadTime:line.leadtime,
bdCost:line.bdcost,
custCost:line.custcost
}]->(b)"
}
importer = new Importer(config)

module.exports = importer