mongoose = require('mongoose')
Resource = require('resourcejs')
Neo4jRepository = require('../source/repositories/Neo4jRepository')
config = require('../config/configuration')

repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepository(repoConfig)

module.exports = (app, model) ->
    resource = Resource(app, '/nodetypes/:nodesType', 'nodes', model)
    .get({ # todo: move this code snippit out to a separate class and unit test it.
        before: (req, res, next) ->
            example = {id: req.params.nodesId, type: req.params.nodesType}
            console.log(JSON.stringify(example,null,3))
            repo.get(example, (error, result) ->
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
    .index({ # todo: move this code snippit out to a separate class and unit test it.
        before: (req, res, next) ->

            repo.index(req.params.nodesType, req.query, (error, result) ->
                if (error?)
                    res.send {error: error.fields[0].message}
                    return
                res.send JSON.stringify(result)
                return
            )
            return
    })

    return resource