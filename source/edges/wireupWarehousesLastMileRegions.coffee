Importer = require('./../importers/ImportFromCSV')

module.exports = (config) ->

    config.cypher = "MATCH (s:Warehouse),(c:Region {id:'00000'})"+
            " MERGE (s)-[e:LAST_MILE{id:'00000'}]->(c)"+
            " ON CREATE SET e.PostalCode='00000',e.id='00000'"+
            " ON MATCH SET e.PostalCode='00000',e.id='00000'"

    return new Importer(config)