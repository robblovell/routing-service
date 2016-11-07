
class TestRepository extends iGraphRepository
    constructor: (@config) ->
        return

    find: (example, callback) ->
        @run(cypher, {}, callback)

    run: (cypher, data, callback=null) ->
        callback(null, {proc: "run"})
        return

    get: (example, callback) ->
        if (example.id == "" or example.id == null)
            callback(null,"{}")
            return
        @run("", example, callback)

    index: (nodesType, query, callback) ->
        @run("", {}, callback)

    add: (cypher, callback) ->
        throw new Error 'not implemented'

    indexEdge: (edgesType, query, callback) ->
        @run("", {}, callback)

    getEdge: (example, callback) ->
        @run("", example, callback)

    setEdge: (params, edge, callback) =>
        callback(null, {proc: "setEdge"})
        return


    set: (id, obj, callback) =>
        callback(null, {proc: "set"})
        return

    deleteEdge: (edgeid, edgekind, callback) ->
        callback(null, {proc: "deleteEdge"})
        return

    delete: (nodeid, nodekind, callback) ->
        callback(null, {proc: "delete"})
        return

    pipeline: () ->
        return

    exec: (callback) =>

        callback(null, "success")

module.exports = TestRepository
