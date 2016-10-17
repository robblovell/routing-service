should = require('should')
assert = require('assert')
sinon = require('sinon')
mock = require('mock-require')
class Repo
    constructor: () ->
    run: (cypher, thing, callback) ->
        callback(null, cypher)
        return
describe 'Test Import From CSV', () ->

    repo = new Repo()

    Importer = require('./../source/importers/ImportFromCSV')

    importer = new Importer({cypher: "CREATE (:Product {id:line.id})", repo: repo})
    it 'constructs corret query', () ->
        query = importer.testonly_setQuery("somefile.csv","CREATE (:Product {id:line.id})")
        query.should.be.equal("USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS FROM 'somefile.csv' AS line CREATE (:Product {id:line.id})")
        return
