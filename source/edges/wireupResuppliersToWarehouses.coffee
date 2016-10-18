Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "RESUPPLIES"
    config.origin = "Warehouse"
    config.originid = "SuperDCLocationID"
    config.destination = "Warehouse"
    config.destinationid = "WarehouseId"
    return new Importer(config)