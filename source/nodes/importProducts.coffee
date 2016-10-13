Importer = require('./../importers/ImportFromCSVWithTemplate')

config = {
    cypher: "CREATE (:Product {
id:line.{{header0}},
productId:line.{{header0}}
})"
}

importer = new Importer(config)

module.exports = importer

