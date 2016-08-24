// Generated by CoffeeScript 1.10.0
(function() {
  var Neo4jRepostitory, Papa, assert, async, config, fs, repo, repoConfig, should;

  should = require('should');

  assert = require('assert');

  async = require('async');

  Neo4jRepostitory = require('../../source/repositories/Neo4jRepository');

  fs = require('fs');

  Papa = require('babyparse');

  config = require('../../config/configuration');

  repoConfig = {
    url: config.neo4jurl
  };

  repo = new Neo4jRepostitory(repoConfig);

  describe('Import Relationship Warehouses To GlobalZone', function() {
    var runtest;
    runtest = function(testImport, callback) {
      var importer;
      console.log("import" + testImport.importer);
      importer = require(testImport.importer);
      importer["import"](testImport.source, repo, function(error, results) {
        if ((error != null)) {
          console.log(error);
          assert(false);
        }
        callback(error, results);
      });
    };
    return it('wireup Warehouses To GlobalZone', function(callback) {
      var importer;
      importer = {
        importer: '../../source/wireupWarehousesToGlobalZone',
        source: null
      };
      runtest(importer, function(error, result) {
        callback(error, result);
      });
    });
  });

}).call(this);

//# sourceMappingURL=test_wireup_edges_warehouse_to_global.js.map
