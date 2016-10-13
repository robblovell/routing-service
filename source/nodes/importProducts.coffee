Importer = require('./../importers/ImportFromCSV')

config = {
    cypher: "CREATE (:Product {
id:line.{{ProductItemId}},
productItemId:line.{{ProductItemId}}
})"
    source: ""
}

importer = new Importer(config)

module.exports = importer

