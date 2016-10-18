Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "BELONGS_TO"
    config.origin = "Product"
    config.destination = "Warehouse"
    return new Importer(config)