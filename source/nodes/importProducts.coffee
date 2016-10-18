Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "Product"
    return new Importer(config)

