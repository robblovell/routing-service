Importer = require('./../importers/ImportFromCSVWithTemplate')

config = {
    cypher: "CREATE (:Product {
id:line.{{header0}},
ProductItemId:line.{{header0}}
})"
}

importer = new Importer(config)

module.exports = importer

