
Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "SIPS_TO"
    config.origin = "Seller"
    config.destination = "Warehouse"
    return new Importer(config)