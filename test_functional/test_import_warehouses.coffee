should = require('should')
assert = require('assert')

importer = require('../src/importWarehouses')
async = require('async')

Neo4jRepostitory = require('../src/repositories/Neo4jRepository')
fs = require('fs');
Papa = require('babyparse')

describe 'Import Warehouses', () ->

    it 'Imports Warehouses Neo4j', (done) ->
        repoConfig = { user: 'neo4j', pass: 'macro7' }
        repo = new Neo4jRepostitory(repoConfig)
        source = 'https://s3-us-west-1.amazonaws.com/bd-ne04j/BDWP.csv'
        importer.import(source, repo, (error, results) ->
            if (error?)
                console.log(error)
                assert(false)
                done(); return
            # do a spot check:
            repo.get({id: '2000502', type: 'Warehouse'}, (error, result) ->
                if (error?)
                    assert(false)
                    done(); return
                data = JSON.parse(result)
                data.id.should.be.equal('2000502')

                return
            )
            return

        )

