Importer = require('./importers/ImportFromCSV')

config = {
    cypher: "MATCH (s:Seller),(c:Zone {id:'99999'})
CREATE (s)-[:LAST_MILE{
zip:'000'
}]->(c)"
}
importer = new Importer(config)

module.exports = importer