_ = require('lodash')

module.exports = (app, resources, spec='/spec', config) ->
    paths = {}
    definitions = {}
    _.each(resources, (resource) ->

        swagger = resource.swagger()
#        if (swagger.paths["/routes"]?)
#            swagger.paths["/routes"].get.parameters.push({
#                    name: 'query',
#                    in: 'query',
#                    description: 'Query by example. Pass a JSON object to find, for example: {"to": "313"}.',
#                    type: 'string',
#                    required: false,
#                    default: ''
#                }
#            )
#        if (swagger.paths["/nodetypes/{nodesType}/nodes"]?)
#            swagger.paths["/nodetypes/{nodesType}/nodes"].get.parameters.push({
#                    name: 'query',
#                    in: 'query',
#                    description: 'Query by example. Pass a JSON object or where clause string to find. JSON example: {"postalCode": "60440", "name": "BDWP IL - Bolingbrook"}  Where Clause Example: "n.postalCode  = \'60440\' and n.name = \'BDWP IL - Bolingbrook\'" (include the quotes).',
#                    type: 'string',
#                    required: false,
#                    default: ''
#                }
#            )
#        if (swagger.paths["/edgetypes/{edgesType}/edges"]?)
#            swagger.paths["/edgetypes/{edgesType}/edges"].get.parameters.push({
#                    name: 'query',
#                    in: 'query',
#                    description: 'Query by example. Pass a JSON object or where clause string to find. JSON example: {"id": "2000507_2000819"}  Where Clause Example: "toInt(e.leadTime)>2 and toInt(e.sellerCost)=0" (include the quotes).',
#                    type: 'string',
#                    required: false,
#                    default: ''
#                }
#            )
        paths = _.assign(paths, swagger.paths)
        definitions = _.assign(definitions, swagger.definitions)
    )
#    for path,verbs of paths
#        if verbs?
#            for key, verb of verbs
#                if verb.parameters
#                    for parameter,i in verb.parameters
#                        if parameter.name? and parameter.name is 'count'
#                            verb.parameters.splice(i, 1)
#                            break
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
