Importer = require('./../importers/ImportFromCSV')

module.exports = (config) ->

    config.cypher = "MATCH (s:Seller {id:line.SellerLocationID}),(b:Warehouse {id:line.BDWPLocationID})
CREATE (s)-[:SWEPT_TO{
sellerCost:line.sellercost,
leadTime:line.leadtime,
bdCost:line.bdcost,
custCost:line.custcost,
id:s.id+'_'+b.id
}]->(b)"

    return new Importer(config)