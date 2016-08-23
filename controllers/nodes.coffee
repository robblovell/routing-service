mongoose = require('mongoose')
Resource = require('resourcejs')

module.exports = (app, model) ->
    resource = Resource(app, '', 'Nodes', model)
    .patch({
        before: (req, res, next) ->
            traverse = require('helpers/traverse')

            if not(req.body? and req.body[0]? and req.body[0].op?)
                result = traverse(req.body[0],'', [])
                req.body[0] = result[0]

    })
    .get({
        before: (req, res, next) ->

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

    })

    return resource