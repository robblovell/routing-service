iImport = require('./iImport')
fs = require('fs');

class ImporterFromCSV extends iImport
    constructor: (@config={}) ->
        console.log("config: "+JSON.stringify(@config))

    # add all to key value store.
    import: (source, repo, callback) ->
        console.log("the source is:"+source)

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

module.exports = ImporterFromCSV