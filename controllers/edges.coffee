mongoose = require('mongoose')
Resource = require('resourcejs')
Neo4jRepository = require('../source/repositories/Neo4jRepository')
config = require('../config/configuration')

repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepository(repoConfig)

module.exports = (app, model) ->
    resource = Resource(app, '/edgetypes/:edgesType', 'edges', model)
    .get({
        before: (req, res, next) ->
            example = {id: req.params.edgesId, type: req.params.edgesType}
            console.log(JSON.stringify(example,null,3))
            repo.getEdge(example, (error, result) ->
                if (error?)
                    res.send {error: Error.message}
                    return
                res.send JSON.stringify(result)
                return
            )
            return
    })
    .put({
        before: (req, res, next) ->

    })
    .post({
        before: (req, res, next) ->

    })
    .delete({
        before: (req, res, next) ->

    })
    .index({
        before: (req, res, next) ->
            repo.indexEdge(req.params.edgesType, req.query, (error, result) ->
                if (error?)
                    res.send {error: error.fields[0].message}
                    return
                res.send JSON.stringify(result)
                return
            )
    })

    return resource