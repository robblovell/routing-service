module.exports = (repo) ->
    handlers = {
        get: (req, res, next) ->
            example = { id: req.params.edgesId, type: req.params.edgesType }
            repo.getEdge(example, (error, result) ->
                if (error?)
                    res.send {error: Error.message, StatusCode: 500}
                    return
                res.send JSON.stringify({ StatusCode: 200, Content: result})
                return
            )
            return
        put: (req, res, next) -> # todo: move this code snippit out to a separate class and unit test it.
            body = req.body
            if !req.params.edgesId? and !body.sourceId? and ! body.destinationId?
                res.send {error: "Must set the id in the path", StatusCode: 400}
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
                        res.send {error: error.fields[0].message, StatusCode: error.fields[0].code}
                    else
                        res.send {error: "error in put: "+JSON.stringify(error), StatusCode: 500}
                    return
                res.send JSON.stringify({ StatusCode: 200, Content: result}) #{ query: result, data: req.properties)
                return
            )
            return
        post: (req, res, next) -> # todo: move this code snippit out to a separate class and unit test it.
            req.body.kind = req.params.edgesType
            repo.setEdge(req.body, req.body.properties, (error, result) ->
                if (error?)
                    if error.fields?
                        res.send {error: error.fields[0].message, StatusCode: error.fields[0].code}
                    else
                        res.send {error: "error in post: "+JSON.stringify(error), StatusCode: 500}
                    return
                res.send JSON.stringify({ StatusCode: 200, Content: result})
                return
            )
            return
        delete:  (req, res, next) ->
            repo.deleteEdge(req.params.edgesId, req.params.edgesType, (error, result) ->
                if (error?)
                    if error.fields?
                        res.send {error: error.fields[0].message, StatusCode: error.fields[0].code}
                    else
                        res.send {error: "error in post: "+JSON.stringify(error), StatusCode: 500}
                    return
                res.send JSON.stringify({ StatusCode: 200, Content: result})
                return
            )
            return
    }
    return handlers
