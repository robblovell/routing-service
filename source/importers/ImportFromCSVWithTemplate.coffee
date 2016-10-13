iImport = require('./iImport')
fs = require('fs');
combyne = require('combyne')

Reader = require('./ReadHeader')
class ImporterFromCSVWithTemplate extends iImport
    cypherTemplate = null
    constructor: (@config={}) ->
        console.log("config: "+@config)
        cypherTemplate = combyne(@config.cypher)

    # add all to key value store.
    import: (source, repo, callback) =>

        reader = new Reader(source) # file that will be imported.
        # get the header names, these are the values that need to be plugged into the template.

        reader.read((error, result) =>
            # result is a comma separated string:
            # holes in the template are labeled: header #
            result = result.split(',')
            data = {}
            for value,ix in result
                key = 'header'+ix
                data[key] = value

            cypher = cypherTemplate.render(data)
            console.log("the cypher is:"+cypher)
            if (source?)
                query = "USING PERIODIC COMMIT 1000 "
                query += "LOAD CSV WITH HEADERS FROM '"+source+"' AS line "
                query += cypher
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
        )



module.exports = ImporterFromCSVWithTemplate