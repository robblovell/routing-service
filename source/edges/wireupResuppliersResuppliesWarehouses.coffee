Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
#    config.type = "RESUPPLIES"
    config.type = "TRANSFERS"
    config.origin = "Warehouse"
    config.originid = "ResupplierId"
    config.originmatchidname = "WarehouseId"
    config.destination = "Warehouse"
    config.destinationid = "WarehouseId"

    return new Importer(config)