Importer = require('./../importers/ImportCSV')

module.exports = (config) ->
    config.type = "LAST_MILE"
    config.origin = "Satellite"
    config.originid = "SatelliteId"
    config.destination = "Region"
    config.destinationid = "RegionId"

    return new Importer(config)