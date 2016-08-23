mongoose = require('mongoose')
Resource = require('resourcejs')

module.exports = (app, model) ->
    resource = Resource(app, '', 'Routes', model)
    .get()
    .post({
        before: (req, res, next) ->
            next()
            return
        after: (req, res, next) ->
            next()
            return
    })
    .delete()
    .index({
        before: (req, res, next) ->
            if (req.query.query?)
                req.modelQuery = this.model.find(JSON.parse(req.query.query))
                req.query.query = null
            next()
            return
    })

    return resource
