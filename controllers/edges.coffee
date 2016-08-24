mongoose = require('mongoose')
Resource = require('resourcejs')
Neo4jRepository = require('../source/repositories/Neo4jRepository')
config = require('../config/configuration')

repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepository(repoConfig)

module.exports = (app, model) ->
    resource = Resource(app, '/edgetypes/:edgesType', 'edges', model)
    .get({ # todo: move this code snippit out to a separate class and unit test it.
        before: (req, res, next) ->
            example = {id: req.params.edgesId, type: req.params.edgesType}
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
        before: (req, res, next) -> # todo: move this code snippit out to a separate class and unit test it.
            req.body.properties.id = req.params.edgesId
            # TODO:: same code as post?
            req.body.kind = req.params.edgesType
            repo.setEdge(req.body, req.body.properties, (error, result) ->
                if (error?)
                    if error.fields?
                        res.send {error: error.fields[0].message, code: error.fields[0].code}
                    else
                        res.send {error: "error in put: "+JSON.stringify(error)}
                    return
                res.send JSON.stringify(result)
                return
            )
            return
    })
    .post({
        before: (req, res, next) -> # todo: move this code snippit out to a separate class and unit test it.
            req.body.kind = req.params.edgesType
            repo.setEdge(req.body, req.body.properties, (error, result) ->
                if (error?)
                    if error.fields?
                        res.send {error: error.fields[0].message, code: error.fields[0].code}
                    else
                        res.send {error: "error in post: "+JSON.stringify(error)}
                    return
                res.send JSON.stringify(result)
                return
            )
            return
    })
    .delete({
        before: (req, res, next) ->
            repo.deleteEdge(req.params.edgesId, req.params.edgesType, (error, result) ->
                if (error?)
                    if error.fields?
                        res.send {error: error.fields[0].message, code: error.fields[0].code}
                    else
                        res.send {error: "error in post: "+JSON.stringify(error)}
                    return
                res.send JSON.stringify(result)
                return
            )
            return

    })
    .index({ # todo: move this code snippit out to a separate class and unit test it.
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