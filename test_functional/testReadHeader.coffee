should = require('should')
assert = require('assert')
nock = require('nock')
Reader = require('../source/importers/ReadHeader')

describe 'Test Read Header', () ->

    it 'reads headers from s3 https endpoint', (done) ->
        reader = new Reader('https://s3-us-west-1.amazonaws.com/bd-ne04j/Satellite.csv')
        reader.read((error, result) ->
            result.should.be.equal('WarehouseID,BDWPWarehouseID,Name,PostalCode')
            done()
        )
