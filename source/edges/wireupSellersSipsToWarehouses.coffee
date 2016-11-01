
Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
#    config.type = "SIPS_TO"
    config.type = "TRANSFERS"
    config.origin = "Warehouse"
    config.originid = "SellerId"
    config.originmatchidname = "WarehouseId"
    config.destination = "Warehouse"

    config.fieldMap = {SellerId: "WarehouseId"}
    config.injectFields = {isSip: '1', isSweep: '0', type: 'SIPS_TO'}

    return new Importer(config)

