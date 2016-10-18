Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "LAST_MILE"
    config.origin = "Satellite"
    config.originid = "ExternalLocationKey"
    config.destination = "Region"
    config.originid = "RadiusZipId"

    return new Importer(config)