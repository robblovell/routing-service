iImport = require('./iImport')
fs = require('fs');

class ImporterFromCSV extends iImport
    cypher = null
    repo = null
    constructor: (@config={}) ->
#        console.log("config: "+JSON.stringify(@config))
        cypher = @config.cypher
        repo = @config.repo
        return

    setConfig: (config) ->
        cypher = config.cypher
        repo = config.repo

    setCypher: (_cypher) ->
        cypher = _cypher

    setRepo: (_repo) ->
        repo = _repo

    setQuery = (source, cypher) ->
        query = "USING PERIODIC COMMIT 1000 "
        query += "LOAD CSV WITH HEADERS FROM '"+source+"' AS line "
        query += cypher

        return query

    # add all to key value store.
    import: (source, callback) =>
        console.log("the source is:"+source)

        if (source?)
            query = setQuery(source, cypher)
            repo.run(query, {}, (error, result) =>
                if (error?)
                    console.log(""+JSON.stringify(error))
                    callback(error, null)
                else
                    callback(null, result)
                return
            )
        else
            repo.run(cypher, {}, (error, result) =>
                if (error?)
                    console.log(""+JSON.stringify(error))
                    callback(error, null)
                else
                    callback(null, result)
                return
            )
        return

    # test-code
    ImporterFromCSV.prototype["_testaccess_setQuery"] = setQuery
    # end-test-code
module.exports = ImporterFromCSV