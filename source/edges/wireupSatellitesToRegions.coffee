Importer = require('./../importers/ImportFromCSV')

config = {
    cypher: "MATCH (s:Satellite {id:line.ExternalLocationKey}),(b:Region {id:line.RadiusZipId})
CREATE (s)-[:LAST_MILE{
id:s.id+'_'+line.RadiusZipId,
zip:line.RadiusZip
}]->(b)"
}
importer = new Importer(config)

module.exports = importer