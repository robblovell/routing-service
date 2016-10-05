mongoose = require('mongoose')
Resource = require('resourcejs')
async = require('async')
config = require('../config/configuration')
Neo4jRepostitory = require('../source/repositories/Neo4jRepository')

repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepostitory(repoConfig)

QueryRoutes = require('../source/queries/QueryRoutes')
queryRoute = new QueryRoutes({})
module.exports = (app, model) ->
    resource = Resource(app, '', 'Routes', model)
    .get()
    .post({ # todo: move this code snippit out to a separate class and unit test it.
        before: (req, res, next) ->
            queries = []
            makeQuery = (to, sku) ->
                return (callback) ->
                    queryRoute.query({to: to, sku: sku}, repo, (error, result) ->
                        if (!error?)
                            result = {sku: sku, routes: result}
                        callback(error, result)
                    )

            for sku in req.body.skus
                queries.push(makeQuery(req.body.to, sku))

            async.parallelLimit(queries, 10, (error, result) ->
                if (error?)
                    res.render('error', {
                        error: {status: "Error finding and creating routes", stack: "In controllers/Routes"},
                        message: ' Error is' + error.message
                    })
                else
                    req.body.routes = result # todo add the routes properly to the request so they get posted to mongodb and returned.
                    next()
            )
            return
    })
    .delete()
    .index({ # todo: move this code snippit out to a separate class and unit test it.
        before: (req, res, next) ->
            if (req.query.query?)
                req.modelQuery = this.model.find(JSON.parse(req.query.query))
                req.query.query = null
            next()
            return
    })
    return resource
