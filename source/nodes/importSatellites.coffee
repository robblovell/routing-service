Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "Satellite"
    return new Importer(config)

