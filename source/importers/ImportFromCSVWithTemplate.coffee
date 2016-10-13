iImport = require('./iImport')
fs = require('fs');
combyne = require('combyne')

class Importer extends iImport
    constructor: (@config={}) ->

    # add all to key value store.
    import: (repo, callback) ->

        source = combyne.render({}, @config.template)
        if (source?)
            query = "USING PERIODIC COMMIT 1000 "
            query += "LOAD CSV WITH HEADERS FROM '"+source+"' AS line "
            query += @config.cypher
            repo.run(query, {}, (error, result) =>
                if (error?)
                    console.log(""+JSON.stringify(error))
                    callback(error, null)
                else
                    callback(null, result)
                return
            )
        else
            repo.run(@config.cypher, {}, (error, result) =>
                if (error?)
                    console.log(""+JSON.stringify(error))
                    callback(error, null)
                else
                    callback(null, result)
                return
            )
        return

module.exports = Importer