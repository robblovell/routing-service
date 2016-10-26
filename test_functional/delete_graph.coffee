should = require('should')
assert = require('assert')

config = require('../config/configuration')
Neo4jRepostitory = require('../source/repositories/Neo4jRepository')
repoConfig = {url: config.neo4jurl}
repo = new Neo4jRepostitory(repoConfig)

describe 'Delete Graph', () ->

    deleteGraph = (done) ->
        console.log("Delete edges")

        repo.run("MATCH ()-[r]->() DELETE r", {}, (error, result) ->
            console.log("error deleting edges:"+error) if error?
            console.log("Delete nodes")

            repo.run("MATCH (n) delete n", {}, (error, result) ->
                console.log("delete completed")
                done()
            ) unless error?
            return
        )
        return

    it 'deleting graph', (done) ->
        deleteGraph(()->
            done()
        )