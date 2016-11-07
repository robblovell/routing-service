should = require('should')
assert = require('assert')
mock = require('mock-require')

handlerMaker = require('../controllers/handlers/edgesHandlers')

describe 'Test Read Header', () ->

    it 'reads edge', (done) ->
        calls = 0
        repo = {
            getEdge: (example, callback) ->
                calls+=1
                callback(null, {calls: calls})
        }
        edgeHandler = handlerMaker(repo)
        edgeHandler.get(
            {
                params: { edgesId: '1234', type: 'EDGE' },
            }
            ,
            {
                send: (value) ->
                    value.should.be.equal('{"calls":1}')
                    done()
                    return
            },
            { }
        )

    it 'updates edge with id_id in path', (done) ->
        putContents = {
            body: { kind: "EDGE", properties: {prop: 1} }#,sourceId: '1234', destinationId: '5678' }
            params: { edgesId: '1234_5678', type: 'EDGE' },

        }
        calls = 0
        repo = {
            setEdge: (body, properties, callback) ->
                body.sourceId.should.be.equal('1234')
                body.destinationId.should.be.equal('5678')
                properties.should.be.equal(putContents.body.properties)
                calls+=1
                callback(null, {calls: calls})
        }
        edgeHandler = handlerMaker(repo)
        edgeHandler.put(
            putContents
        ,
            {
                send: (value) ->
                    value.should.be.equal('{"calls":1}')
                    done()
                    return
            },
            { }
        )
    it 'updates edge with ids set explicitly', (done) ->
        putContents = {
            body: { kind: "EDGE", properties: {prop: 1},sourceId: '1234', destinationId: '5678' }
            params: { edgesId: '1234_5678', type: 'EDGE' },

        }
        calls = 0
        repo = {
            setEdge: (body, properties, callback) ->
                body.sourceId.should.be.equal('1234')
                body.destinationId.should.be.equal('5678')
                properties.should.be.equal(putContents.body.properties)
                calls+=1
                callback(null, {calls: calls})
        }
        edgeHandler = handlerMaker(repo)
        edgeHandler.put(
            putContents
        ,
            {
                send: (value) ->
                    value.should.be.equal('{"calls":1}')
                    done()
                    return
            },
            { }
        )

    it 'edge update returns error with with no ids set', (done) ->
        putContents = {
            body: { kind: "EDGE", properties: {prop: 1} }
            params: {  type: 'EDGE' }

        }
        calls = 0
        repo = {
            setEdge: (body, properties, callback) ->
                body.sourceId.should.be.equal('1234')
                body.destinationId.should.be.equal('5678')
                properties.should.be.equal(putContents.body.properties)
                calls+=1
                callback(null, {calls: calls})
        }
        edgeHandler = handlerMaker(repo)
        edgeHandler.put(
            putContents
        ,
            {
                send: (value) ->
                    value.error.should.be.equal("Must set the id in the path")
                    value.code.should.be.equal(400)
                    done()
                    return
            },
            { }
        )