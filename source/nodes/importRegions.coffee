Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "Region"
    return new Importer(config)