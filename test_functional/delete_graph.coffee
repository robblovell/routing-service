should = require('should')
assert = require('assert')

config = require('../config/configuration')
Neo4jRepostitory = require('../source/repositories/Neo4jRepository')
repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepostitory(repoConfig)

describe 'Delete Graph', () ->
    @timeout(30*60*1000) # 30 minutes

#    fail = (done) ->
#        try
#            assert(false)
#        catch e
#            done()
#
#    deleteGraph = (done) ->
#        console.log()
#        console.log("Delete edges")
#
#        repo.run("MATCH ()-[r]->() DELETE r", {}, (error, result) ->
#            if error?
#                console.log("Error deleting edges: "+JSON.stringify(error))
#                fail(done)
#            else
#                console.log("Delete nodes")
#
#                repo.run("MATCH (n) delete n", {}, (error, result) ->
#                    if error?
#                        console.log("Error deleting nodes: "+JSON.stringify(error))
#                        fail(done)
#                    else
#                        console.log("delete completed")
#                        done()
#                ) unless error?
#            return
#        )
#        return
#
#    it 'deleting graph', (done) ->
#        deleteGraph(done)