Importer = require('./../importers/ImportFromCSV')

module.exports = (config) ->

    config.cypher = "MATCH (s:Warehouse {id:line.SuperDCLocationID}),(b:Warehouse {id:line.BDWPLocationID})
CREATE (s)-[:RESUPPLIES{
sellerCost:line.sellercost,
leadTime:line.leadtime,
bdCost:line.bdCost,
custCost:line.custCost,
id:s.id+'_'+b.id
}]->(b)"

    return new Importer(config)