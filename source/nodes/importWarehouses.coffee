Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "Warehouse"
    return new Importer(config)