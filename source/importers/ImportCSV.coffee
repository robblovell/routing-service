iImport = require('./iImport')
fs = require('fs');
combyne = require('combyne')
async = require('async')
ReadHeader = require('./ReadHeader')
ImportFromCSV = require('./ImportFromCSV')
Neo4jMakeUpsert = require('../queries/Neo4jMakeUpsert')

class ImporterCSV extends iImport
    Reader = null
    importer = null
    repo = null
    type = null
    origin = null
    destination = null
    originid = null
    destinationid = null
    constructor: (@config={}, _reader=ReadHeader) ->
#        console.log("config: "+JSON.stringify(@config))
        importer = new ImportFromCSV(@config)
        Reader = _reader
        repo = @config.repo
        type = @config.type
        origin = @config.origin if @config.origin
        destination = @config.destination if @config.destination
        originid = @config.originid if @config.originid
        destinationid = @config.destinationid if @config.destinationid
        return

    typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

    renderFilenames = (sources) ->
        imports = []
        template = combyne(sources.template)
        for i in [0...sources.count]
            data = {number: ("0000"+i).slice(-4), date: sources.date}
            imports.push(template.render(data))
        return imports

    # add all to key value store.\
    import: (sources, callback) =>
        imports = []
        if (typeIsArray(sources))
            for source in sources
                imports.push(runImports(source))
        else if (typeof sources is 'object')
            filenames = renderFilenames(sources)
            imports = []
            for filename in filenames
                imports.push(runImports(filename))
        else if (typeof sources is 'string')
            imports.push(runImports(sources))

        async.series(imports, callback)
        return

    splitResults = (result) ->
        fields = result.split(',')
        data = {}
        for value,ix in fields
            key = 'header'+ix
            data[key] = value
        return [fields, data]

    makeCypher = (fields) ->
        [templateFields, templateData] = splitResults(fields)
        if origin? and destination?
            connections = {
                origin: origin
                destination: destination
                originid: originid
                destinationid: destinationid
            }
            upsertStatement = Neo4jMakeUpsert.makeCSVEdgeUpsert(connections, type, templateFields)
        else
            upsertStatement = Neo4jMakeUpsert.makeCSVUpsert(type, templateFields)
        cypherTemplate = combyne(upsertStatement)

        return cypherTemplate.render(templateData)

    runImports = (source) =>
        return (callback) =>
            reader = new Reader(source) # file that will be imported.
            # get the header names, these are the values that need to be plugged into the template.

            reader.read((error, result) =>
                # result is a comma separated string:
                # holes in the template are labeled: header #

                importer.setCypher (makeCypher(result))
                importer.import(source, callback)
                return
            )

    # test-code
    ImporterCSV.prototype["_testaccess_makeCypher"] = makeCypher
    ImporterCSV.prototype["_testaccess_runImports"] = runImports
    ImporterCSV.prototype["_testaccess_splitResults"] = splitResults
    ImporterCSV.prototype["_testaccess_renderFilenames"] = renderFilenames
    # end-test-code


module.exports = ImporterCSV