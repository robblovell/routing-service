should = require('should')
assert = require('assert')
nock = require('nock')
Reader = require('../source/importers/ReadHeader')

describe 'Test Read Header', () ->

    it 'reads headers from file', (done) ->
        reader = new Reader('file:///test/data/importData.csv')
        reader.read((error, result) ->
            result.should.be.equal('Header1,Header2,Header3,Header4,Header5,Header6')
            done()
        )
        
    it 'reads headers from https endpoint', (done) ->
        nock('https://example.com')
        .get('/importData.csv')
        .reply(200, "Header1,Header2,Header3,Header4,Header5,Header6\r\n2219,2000511,74,5,0,0\r\n27274,2000819,59,8,0,0")

#        reader = new Reader('http://localhost:3000/importData.csv')
        reader = new Reader('https://example.com/importData.csv')
        reader.read((error, result) ->
            result.should.be.equal('Header1,Header2,Header3,Header4,Header5,Header6')
            done()
        )
