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

describe 'Test Import CSV', () ->

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

    Importer = require('./../source/importers/ImportCSV')

    importer = new Importer({cypher: "CREATE (:Product {id:line.{{header0}}})", repo: repo}, ReadHeader)
    it 'splits results', () ->
        [fields, data] = importer._testaccess_splitResults("one,two,three")
        fields[0].should.be.equal("one")
        fields[1].should.be.equal("two")
        fields[2].should.be.equal("three")
        data['header0'].should.be.equal("one")
        data['header1'].should.be.equal("two")
        data['header2'].should.be.equal("three")
        return

    it 'makes cypher from csv header data', (done) ->
        result = importer._testaccess_makeCypher("one,two,three")
        result.should.be.equal("MERGE (n:undefined { id: line.one }) \
ON CREATE SET n.created=timestamp(), \
n.id=line.one,n.one=line.one,n.two=line.two,n.three=line.three \
ON MATCH SET n.updated=timestamp(), \
n.id=line.one,n.one=line.one,n.two=line.two,n.three=line.three")
        done()

    it 'makes cypher from csv header data with replaced and injected fields', (done) ->
        config2 = {}
        config2.fieldMap = {SellerId: "WarehouseId"}
        config2.fieldMap = {one: 'a'}
        config2.injectFields = {four: '1'}
        config2.cypher = "CREATE (:Product {id:line.{{header0}}})"
        config2.repo = repo

        importer2 = new Importer(config2, ReadHeader)

        result = importer2._testaccess_makeCypher("one,two,three")
        result.should.be.equal("MERGE (n:undefined { id: line.one }) \
ON CREATE SET n.created=timestamp(), \
n.id=line.one,n.a=line.one,n.two=line.two,n.three=line.three,n.four='1' \
ON MATCH SET n.updated=timestamp(), \
n.id=line.one,n.a=line.one,n.two=line.two,n.three=line.three,n.four='1'")
        done()

    it 'makes reader function and sets cypher', (done) ->
        importer = new Importer({cypher: "CREATE (:Product {id:line.{{header0}}})", repo: repo}, ReadHeader)

        func = importer._testaccess_runImports("./somefile.csv", null)
        (typeof func).should.be.equal("function")
        func((error, result) ->
            result.should.be.equal("USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS \
FROM './somefile.csv' AS line MERGE (n:undefined { id: line.one }) \
ON CREATE SET n.created=timestamp(), n.id=line.one,n.one=line.one,n.two=line.two,n.three=line.three \
ON MATCH SET n.updated=timestamp(), n.id=line.one,n.one=line.one,n.two=line.two,n.three=line.three")
            done()
        )
        return

    it 'correctly names files that are imported from objects', (done) ->
        sources = { count: 3, date: "20161007", template:'Products_{{date}}_{{number}}.csv' }
        test = 1
        importer.import(sources, (error, result) ->
            done()
        )
        return
    it 'correctly names files that are imported from array', (done) ->
        sources = ['Products_0000.csv', 'Products_20161007_0001.csv', 'Products_20161007_0002.csv']
        test = 1
        importer.import(sources, (error, result) ->
            done()
        )
        return
    it 'correctly names files that are imported from string', (done) ->
        test = 2
        sources = ['Products_20161007_0000.csv']

        importer.import(sources, (error, result) ->
            done()
        )
        return
    it 'renders filenames correctly', (done) ->
        sources = { count: 3, date: "20161007", template:'Products_{{date}}_{{number}}.csv' }
        imports = importer._testaccess_renderFilenames(sources)
        imports[0].should.be.equal('Products_20161007_0000.csv')
        imports[1].should.be.equal('Products_20161007_0001.csv')
        imports[2].should.be.equal('Products_20161007_0002.csv')
        done()
        return

    it 'remaps fields', (done) ->
        templateFields = ['one', 'two', 'three']
        fieldMap = {one: 'a', three: 'b'}
        templateFields = importer._testaccess_remapFields(templateFields, fieldMap)
        templateFields[0].should.be.equal('a')
        templateFields[2].should.be.equal('b')
        done()
        return

