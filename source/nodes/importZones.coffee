Importer = require('./../importers/ImportFromCSV')

config = {
    cypher: "CREATE (:Zone {
id:line.RadiusZipId,
zip:line.RadiusZip})"
}
importer = new Importer(config)

module.exports = importer
