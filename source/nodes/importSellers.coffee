Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "Warehouse"
    config.fieldMap = {SellerId: "WarehouseId"}
    return new Importer(config)