module.exports = (repo) ->
    handlers = {
        get: (req, res, next) ->
            example = { id: req.params.edgesId, type: req.params.edgesType }
            repo.getEdge(example, (error, result) ->
                if (error?)
                    res.send {error: Error.message}
                    return
                res.send JSON.stringify(result)
                return
            )
            return
        put: (req, res, next) -> # todo: move this code snippit out to a separate class and unit test it.
            body = req.body
            if !req.params.edgesId? and !body.sourceId? and ! body.destinationId?
                res.send {error: "Must set the id in the path", code: 400}
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
                        res.send {error: error.fields[0].message, code: error.fields[0].code}
                    else
                        res.send {error: "error in put: "+JSON.stringify(error)}
                    return
                res.send JSON.stringify(result) #{ query: result, data: req.properties)
                return
            )
            return

    }
    return handlers
