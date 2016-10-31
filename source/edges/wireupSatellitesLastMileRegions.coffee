Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "LAST_MILE"
    config.origin = "Warehouse"
    config.originid = "WarehouseId"
    config.destination = "Region"
    config.destinationid = "RegionId"
    config.fieldMap = {SatelliteId: "WarehouseId"}

    return new Importer(config)