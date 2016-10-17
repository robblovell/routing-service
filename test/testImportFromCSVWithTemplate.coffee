should = require('should')
assert = require('assert')
sinon = require('sinon')
mock = require('mock-require')

class ReadHeader
    constructor:  (config) ->
        console.log("mock")
        return
    read: (callback) ->
        callback(null, "one,two,three")
        return

class Repo
    constructor: () ->
    run: (cypher, thing, callback) ->
        callback(null, cypher)
        return

repo = new Repo()

describe 'Test Import From CSV With Template', () ->

    test = 1
    mock('async',
        {
            series: (imports, callback) ->
                if (test is 1)
                    imports.length.should.be.equal(3)
                    (typeof imports[0]).should.be.equal("function")
                    (typeof imports[1]).should.be.equal("function")
                    (typeof imports[2]).should.be.equal("function")
                else
                    imports.length.should.be.equal(1)
                    (typeof imports[0]).should.be.equal("function")
                callback(null, true)
                return
        }
    )
    async = require('async')

    Importer = require('./../source/importers/ImportFromCSVWithTemplate')

    importer = new Importer({cypher: "CREATE (:Product {id:line.{{header0}}})", repo: repo}, ReadHeader)
    it 'splits results', () ->
        data = importer.testonly_splitResults("one,two,three")
        data['header0'].should.be.equal("one")
        data['header1'].should.be.equal("two")
        data['header2'].should.be.equal("three")
        return

    it 'makes reader function and sets cypher', (done) ->
        func = importer.testonly_runImports("./somefile.csv", null)
        (typeof func).should.be.equal("function")
        func((error, result) ->
            result.should.be.equal("USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS FROM './somefile.csv' AS line CREATE (:Product {id:line.one)")
            done()
        )
        return


    it 'correctly names files that are imported from objects', (done) ->
        sources = { count: 3, date: "20161007", name:'Products_{{date}}_{{number}}.csv' }
        importer.import(sources, (error, result) ->
            done()
        )
    it 'correctly names files that are imported from array', (done) ->
        sources = ['Products_0000.csv', 'Products_20161007_0001.csv', 'Products_20161007_0002.csv']
        importer.import(sources, (error, result) ->
            done()
        )
    it 'correctly names files that are imported from string', (done) ->
        test = 2
        sources = ['Products_20161007_0000.csv']

        importer.import(sources, (error, result) ->
            done()
        )
    it 'renders filenames correctly', (done) ->
        sources = { count: 3, date: "20161007", name:'Products_{{date}}_{{number}}.csv' }

        imports = importer.testonly_renderFilenames(sources)
        imports[0].should.be.equal('Products_20161007_00.csv')
        imports[1].should.be.equal('Products_20161007_01.csv')
        imports[2].should.be.equal('Products_20161007_02.csv')
        done()

