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
        before: (req, res, next) -> # todo: move this code snippit out to a separate class and unit test it.
            req.body.id = req.params.nodesId
            # TODO:: same code as post?
            req.body.type = req.params.nodesType
            repo.set(req.body.id, req.body, (error, result) ->
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
    .post({
        before: (req, res, next) -> # todo: move this code snippit out to a separate class and unit test it.
            req.body.type = req.params.nodesType
            repo.set(req.body.id, req.body, (error, result) ->
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
            repo.delete(req.params.nodesId, req.params.nodesType, (error, result) ->
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