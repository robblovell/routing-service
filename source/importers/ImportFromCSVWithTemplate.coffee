iImport = require('./iImport')
fs = require('fs');
combyne = require('combyne')
async = require('async')
Reader = require('./ReadHeader')
class ImporterFromCSVWithTemplate extends iImport
    cypherTemplate = null
    constructor: (@config={}) ->
        console.log("config: "+JSON.stringify(@config))
        cypherTemplate = combyne(@config.cypher)

    typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'
    # add all to key value store.
    import: (sources, repo, callback) =>
        imports = []

        if (typeIsArray(sources))
            for source in sources
                imports.push(runImports(source, repo))
        else if (typeof sources is 'object')
            template = combyne(sources.name)
            for i in [0...sources.count]
                data = {number: ("0"+i).slice(-2)}
                imports.push(runImports(template.render(data), repo))
        else if typeof sources is 'string'
            imports.push(runImports(sources, repo))

        async.series(imports, callback)

    runImports = (source, repo) ->
        return (callback) ->
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
                console.log("the source is:"+source)

                if (source?)
                    query = "USING PERIODIC COMMIT 1000 "
                    query += "LOAD CSV WITH HEADERS FROM '"+source+"' AS line "
                    query += cypher
                    console.log("QUERY:"+query)
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