Importer = require('./../importers/ImportFromCSV')

module.exports = (config) ->

    config.cypher =  "CREATE (:Region {
id:line.RadiusZipId,
zip:line.RadiusZip})"

    return new Importer(config)