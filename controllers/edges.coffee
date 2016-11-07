mongoose = require('mongoose')
Resource = require('resourcejs')
edgeHandler = require('./handlers/edgesHandlers')

module.exports = (app, model, repo) ->
    resource = Resource(app, '/edgetypes/:edgesType', 'edges', model)
    .get({ # todo: move this code snippit out to a separate class and unit test it.
        before: edgeHandler(repo).get
    })
    .put({
        before: edgeHandler(repo).put
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