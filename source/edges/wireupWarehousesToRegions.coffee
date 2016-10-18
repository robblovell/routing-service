Importer = require('./../importers/ImportFromCSV')

module.exports = (config) ->

    config.cypher = "MATCH (s:Warehouse),(c:Region {id:'99999'})
CREATE (s)-[:LAST_MILE{
zip:'000',id:s.id+'_99999'
}]->(c)"

    return new Importer(config)