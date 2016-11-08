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
                    value.should.be.equal('{"StatusCode":200,"Success":true,"Contents":{"calls":1}}')
                    done()
                    return
            },
            { }
        )

    it 'updates edge with id_id in path (sets id explicitly(', (done) ->
        putContents = {
            body: { kind: "EDGE", properties: {prop: 1} , id: '222'}
            params: { edgesId: '1234_5678', type: 'EDGE'},

        }
        calls = 0
        repo = {
            setEdge: (body, properties, callback) ->
                body.sourceId.should.be.equal('1234')
                body.destinationId.should.be.equal('5678')
                body.id.should.be.equal("222")
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
                    value.should.be.equal('{"StatusCode":200,"Success":true,"Contents":{"calls":1}}')
                    done()
                    return
            },
            { }
        )
    it 'updates edge with ids set explicitly (id set implicitly)', (done) ->
        putContents = {
            body: { kind: "EDGE", properties: {prop: 1}, sourceId: '1234', destinationId: '5678' }
            params: { edgesId: '1234_5678', type: 'EDGE' },

        }
        calls = 0
        repo = {
            setEdge: (body, properties, callback) ->
                body.sourceId.should.be.equal('1234')
                body.destinationId.should.be.equal('5678')
                body.id.should.be.equal("1234_5678")
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
                    value.should.be.equal('{"StatusCode":200,"Success":true,"Contents":{"calls":1}}')
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
                    value = JSON.parse(value)
                    value.Contents.should.be.equal("Must set the id in the path")
                    value.StatusCode.should.be.equal(400)
                    value.Success.should.be.equal(false)
                    done()
                    return
            },
            { }
        )