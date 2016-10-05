class OrientDbRepository
    constructor: (@config) ->

    find: (example, callback) ->
        throw new Error("not implemented")

    run: (cypher, data, callback=null) ->
        throw new Error("not implemented")

    get: (example, callback) ->
        throw new Error("not implemented")

    index: (nodesType, query, callback) ->
        throw new Error("not implemented")

    add: (cypher, callback) ->
        throw new Error 'not implemented'

    indexEdge: (edgesType, query, callback) ->
        throw new Error("not implemented")

    getEdge: (example, callback) ->
        throw new Error("not implemented")

    setEdge: (params, edge, callback) =>
        throw new Error("not implemented")

    set: (id, obj, callback) =>
        throw new Error("not implemented")

    deleteEdge: (edgeid, edgekind, callback) ->
        throw new Error("not implemented")

    delete: (nodeid, nodekind, callback) ->
        throw new Error("not implemented")

    pipeline: () ->
        throw new Error("not implemented")

    exec: (callback) =>
        throw new Error("not implemented")

module.exports = OrientDbRepository
