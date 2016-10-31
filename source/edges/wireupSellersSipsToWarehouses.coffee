
Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "SIPS_TO"
    config.origin = "Warehouse"
    config.originid = "SellerId"
    config.originmatchidname = "WarehouseId"
    config.destination = "Warehouse"

    config.fieldMap = {SellerId: "WarehouseId"}

    return new Importer(config)

