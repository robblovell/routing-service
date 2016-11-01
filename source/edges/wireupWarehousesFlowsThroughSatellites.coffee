#Importer = require('./../importers/ImportFromCSV')
#
#module.exports = (config) ->
#
#    config.cypher = "MATCH (b:Warehouse {id:line.BDWPWarehouseID}),(s:Satellite {id:line.SatelliteWarehouseID})
#CREATE (b)-[:FLOWS_THROUGH{
#sellerCost:line.sellercost,
#leadTime:line.leadtime,
#bdCost:line.bdcost,
#custCost:line.custcost,
#id:b.id+'_'+s.id
#}]->(s)"
#
#    return new Importer(config)
#

Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
#    config.type = "FLOWS_THROUGH"
    config.type = "TRANSFERS"
    config.origin = "Warehouse"

    config.destination = "Warehouse"
    config.destinationid = "SatelliteId"
    config.destinationmatchidname = "WarehouseId"
    config.fieldMap = {SatelliteId: "WarehouseId"}
    config.injectFields = {isSip: '0', isSweep: '0', type: 'FLOWS_THROUGH'}

    return new Importer(config)