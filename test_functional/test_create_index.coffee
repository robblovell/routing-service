should = require('should')
assert = require('assert')
async = require('async')
Neo4jRepostitory = require('../source/repositories/Neo4jRepository')

config = require('../config/configuration')

repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepostitory(repoConfig)

describe 'Create Indexes', () ->
    nodes = ["Product", "Region", "Warehouse", "Satellite"]
    @timeout(5*60*1000) # 5 minutes

    makeNodeIndexCreator = (node) ->
        return (done) ->
            repo.pipeline()

            repo.run("CREATE INDEX ON :"+node+"(id)", {})
            repo.run("CREATE INDEX ON :"+node+"("+node+"Id)", {})
            repo.exec((error, result) ->
                done()
            )

    it 'Creates id Node Indexes', (done) ->
        commands = []
        for node in nodes
            commands.push(makeNodeIndexCreator(node))

        async.series(commands, (error, result) ->
            done()
        )

#    edges = ["BELONGS_TO", "FLOWS_THROUGH", "SWEPT_TO", "SIPS_TO", "DELIVERS_TO", "RESUPPLIES"]
#
#    makeEdgeIndexCreator = (edge) ->
#        return (done) ->
#            repo.pipeline()
#
#            repo.run("CREATE INDEX ON :"+edge+"(id)", {})
#            repo.exec((error, result) ->
#                done()
#            )
#
#    it 'Creates id Edge Indexes', (done) ->
#        commands = []
#        for edge in edges
#            commands.push(makeEdgeIndexCreator(edge))
#
#        async.series(commands, (error, result) ->
#            done()
#        )
#
#    it 'Creates Product Inventory Index', (done) ->
#        repo.pipeline()
#        repo.run("CREATE INDEX ON :Product(Inventory)", {})
#        repo.exec((error, result) ->
#            done()
#        )
