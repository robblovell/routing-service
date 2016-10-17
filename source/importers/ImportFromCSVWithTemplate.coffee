iImport = require('./iImport')
fs = require('fs');
combyne = require('combyne')
async = require('async')

ImportFromCSV = require('./ImportFromCSV')

class ImporterFromCSVWithTemplate extends iImport
    cypherTemplate = null
    Reader = null
    importer = null
    repo = null
    constructor: (@config={}, _reader) ->
        console.log("config: "+JSON.stringify(@config))
        cypherTemplate = combyne(@config.cypher)
        importer = new ImportFromCSV(@config)
        Reader = _reader
        repo = @config.repo
        return

    typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

    renderFilenames = (sources) ->
        imports = []
        template = combyne(sources.name)
        for i in [0...sources.count]
            data = {number: ("0"+i).slice(-2), date: sources.date}
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
        result = result.split(',')
        data = {}
        for value,ix in result
            key = 'header'+ix
            data[key] = value
        return data

    runImports = (source) =>
        return (callback) =>
            reader = new Reader(source) # file that will be imported.
            # get the header names, these are the values that need to be plugged into the template.

            reader.read((error, result) =>
                # result is a comma separated string:
                # holes in the template are labeled: header #
                data = splitResults(result)
                importer.setCypher (cypherTemplate.render(data))
                importer.import(source, callback)
                return
            )

    # test-code
    ImporterFromCSVWithTemplate.prototype["testonly_runImports"] = runImports
    ImporterFromCSVWithTemplate.prototype["testonly_splitResults"] = splitResults
    ImporterFromCSVWithTemplate.prototype["testonly_renderFilenames"] = renderFilenames
    # end-test-code


module.exports = ImporterFromCSVWithTemplate