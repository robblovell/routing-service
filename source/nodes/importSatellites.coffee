Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "Warehouse"
    config.fieldMap = {SatelliteId: "WarehouseId"}
    return new Importer(config)

