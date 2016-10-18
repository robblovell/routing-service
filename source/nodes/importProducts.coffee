Importer = require('./../importers/ImportFromCSVWithTemplate')

module.exports = (config) ->
    config.cypher = "CREATE (:Product {
id:line.{{header0}},
ProductItemId:line.{{header0}}
})"
    return new Importer(config)


