_ = require('lodash')

module.exports = (app, resources, spec='/spec', config) ->
    paths = {}
    definitions = {}
    _.each(resources, (resource) ->

        swagger = resource.swagger()
        if (swagger.paths["/edgetypes/{edgesType}/edges/{edgesId}"]?)
            idHelpString = 'The id of the edge that will be updated. The id is a combination of source and destination node ids of the form: sourceId_destinationId'
            typeHelpString = "The neo4j 'Relationship Type' of the edge/relationship"
            swagger.paths["/edgetypes/{edgesType}/edges/{edgesId}"].put.parameters[0].description=idHelpString
            swagger.paths["/edgetypes/{edgesType}/edges/{edgesId}"].put.parameters[2].description=typeHelpString
            swagger.paths["/edgetypes/{edgesType}/edges/{edgesId}"].get.parameters[0].description=idHelpString
            swagger.paths["/edgetypes/{edgesType}/edges/{edgesId}"].get.parameters[1].description=typeHelpString
            swagger.paths["/edgetypes/{edgesType}/edges/{edgesId}"].delete.parameters[0].description=idHelpString
            swagger.paths["/edgetypes/{edgesType}/edges/{edgesId}"].delete.parameters[1].description=typeHelpString
        if (swagger.paths["/edgetypes/{edgesType}/edges"]?)
            swagger.paths["/edgetypes/{edgesType}/edges"].post.parameters[1].description=typeHelpString
            swagger.paths["/edgetypes/{edgesType}/edges"].get.parameters[5].description=typeHelpString
        paths = _.assign(paths, swagger.paths)
        definitions = _.assign(definitions, swagger.definitions)
    )

    # Define the specification.
    specification = {
        swagger: '2.0',
        info: {
            description: 'Network Persister',
            version: config.version,
            title: 'Network Persister',
            contact: {
                name: 'Build Direct'
            },
#            license: {
#                name: 'MIT',
#                url: 'http://opensource.org/licenses/MIT'
#            }
        },
        host: config.host_url,
        basePath: config.basepath,
        schemes: [config.scheme],
        definitions: definitions,
        paths: paths
#        authorizations: {
#            oauth2: [
#                {scope: "full"
#                }
#            ]
#        }
    }

    # Show the specification at the URL.
    app.get(spec, (req, res, next) ->
        res.json(specification)
    )
