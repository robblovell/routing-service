_ = require('lodash')

module.exports = (app, resources, spec='/spec', config) ->
    paths = {}
    definitions = {}
    _.each(resources, (resource) ->

        swagger = resource.swagger()

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
