Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "Seller"
    return new Importer(config)