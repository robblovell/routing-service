FormatResponse = require('./FormatResponse')


module.exports = (repo) ->
    response = new FormatResponse()
    handlers = {
        get: (req, res, next) ->
            example = { id: req.params.edgesId, type: req.params.edgesType }
            repo.getEdge(example, (error, result) ->
                if (error?)

                    res.send response.make(500, false, Error.message)
                    return
                res.send response.make(200, true, result)
                return
            )
            return
        put: (req, res, next) -> # todo: move this code snippit out to a separate class and unit test it.
            body = req.body
            if !req.params.edgesId? and !body.sourceId? and ! body.destinationId?
                res.send response.make(400, false, "Must set the id in the path")
                return

            if (req.params.edgesId?)
                ids = req.params.edgesId.split('_')
            else
                ids = []
            if (!body.sourceId || !body.destinationId)
                if (!body.sourceId and ids.length > 0)
                    body.sourceId = ids[0]
                if (!body.destinationId and ids.length > 1)
                    body.destinationId = ids[1]

            # TODO:: same code as post?
            req.body.kind = req.params.edgesType
            if !req.body.id?
                req.body.id = req.params.edgesId
            repo.setEdge(req.body, req.body.properties, (error, result) ->
                if (error?)
                    if error.fields?
                        res.send response.make(error.fields[0].code, false, error.fields[0].message)
                    else
                        res.send response.make(400, false, "error in put: "+JSON.stringify(error))
                    return
                res.send response.make(200, true, result)
                return
            )
            return
        post: (req, res, next) -> # todo: move this code snippit out to a separate class and unit test it.
            req.body.kind = req.params.edgesType
            repo.setEdge(req.body, req.body.properties, (error, result) ->
                if (error?)
                    if error.fields?
                        res.send response.make(error.fields[0].code, false, error.fields[0].message)
                else
                    res.send response.make(400, false, "error in post: "+JSON.stringify(error))
                return
                res.send response.make(200, true, result)
                return
            )
            return
        delete:  (req, res, next) ->
            repo.deleteEdge(req.params.edgesId, req.params.edgesType, (error, result) ->
                if (error?)
                    if error.fields?
                        res.send response.make(error.fields[0].code, false, error.fields[0].message)
                    else
                        res.send response.make(400, false, "error in delete: "+JSON.stringify(error))
                    return
                res.send response.make(200, true, result)
                return
            )
            return

        index: (req, res, next) ->
            repo.indexEdge(req.params.edgesType, req.query, (error, result) ->
                if (error?)
                    res.send response.make(error.fields[0].code, false, error.fields[0].message)
                    return
                res.send response.make(200, true, result)
                return
            )
    }
    return handlers
