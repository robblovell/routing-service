Importer = require('./../importers/ImportFromCSV')

module.exports = (config) ->

    config.cypher = "MATCH (s:Satellite {id:line.ExternalLocationKey}),(b:Region {id:line.RadiusZipId})
CREATE (s)-[:LAST_MILE{
id:s.id+'_'+line.RadiusZipId,
zip:line.RadiusZip
}]->(b)"

    return new Importer(config)