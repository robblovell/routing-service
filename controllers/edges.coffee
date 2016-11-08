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
        before: edgeHandler(repo).post
    })
    .delete({
        before: edgeHandler(repo).delete
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