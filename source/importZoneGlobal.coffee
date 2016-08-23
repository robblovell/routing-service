Importer = require('./importers/ImportFromCSV')

config = {
    cypher: "CREATE (:Zone {
id:'99999',
zip:'000'
})"
}
importer = new Importer(config)

module.exports = importer
