Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "BELONGS_TO"
    config.origin = "Product"
    config.destination = "Warehouse"
    config.fieldMap = {SellerId: "WarehouseId"}

    return new Importer(config)

