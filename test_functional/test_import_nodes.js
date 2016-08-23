// Generated by CoffeeScript 1.10.0
(function() {
  var Neo4jRepostitory, Papa, assert, async, config, fs, repo, repoConfig, should;

  should = require('should');

  assert = require('assert');

  async = require('async');

  Neo4jRepostitory = require('../source/repositories/Neo4jRepository');

  fs = require('fs');

  Papa = require('babyparse');

  config = require('../config/configuration');

  repoConfig = {
    url: config.neo4jurl
  };

  repo = new Neo4jRepostitory(repoConfig);

  describe('Import Nodes', function() {
    var runtest;
    runtest = function(testImport, callback) {
      var importer;
      console.log("import" + testImport.nodetype);
      importer = require(testImport.importer);
      importer["import"](testImport.source, repo, function(error, results) {
        if ((error != null)) {
          console.log(error);
          assert(false);
          callback(error, result);
          return;
        }
        repo.get({
          id: testImport.spotid,
          type: testImport.nodetype
        }, function(error, result) {
          var data;
          if ((error != null)) {
            assert(false);
            callback(error, result);
            return;
          }
          data = result[0];
          data.id.should.be.equal(testImport.spotid);
          console.log("completed: " + testImport.nodetype);
          callback(error, result);
        });
      });
    };
    it('Imports satellites to Neo4j', function(callback) {
      var importer;
      importer = {
        importer: '../source/importSatellites',
        source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/Satellite.csv',
        spotid: '2212',
        nodetype: 'Satellite'
      };
      runtest(importer, function(error, result) {
        callback(error, result);
      });
    });
    it('Imports products to Neo4j', function(callback) {
      var importer;
      importer = {
        importer: '../source/importProducts',
        source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/Products.csv',
        spotid: '10081215',
        nodetype: 'Product'
      };
      runtest(importer, function(error, result) {
        callback(error, result);
      });
    });
    it('Imports warehouses to Neo4j', function(callback) {
      var importer;
      importer = {
        importer: '../source/importWarehouses',
        source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/BDWP.csv',
        spotid: '2000507',
        nodetype: 'Warehouse'
      };
      runtest(importer, function(error, result) {
        callback(error, result);
      });
    });
    it('Imports sellers to Neo4j', function(callback) {
      var importer;
      importer = {
        importer: '../source/importSellers',
        source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/Seller.csv',
        spotid: '2000061',
        nodetype: 'Seller'
      };
      runtest(importer, function(error, result) {
        callback(error, result);
      });
    });
    it('Imports zones to Neo4j', function(callback) {
      var importer;
      importer = {
        importer: '../source/importZones',
        source: 'https://s3-us-west-1.amazonaws.com/bd-ne04j/RadiusZips.csv',
        spotid: '15',
        nodetype: 'Zone'
      };
      runtest(importer, function(error, result) {
        callback(error, result);
      });
    });
    return it('Imports global zone to Neo4j', function(callback) {
      var importer;
      importer = {
        importer: '../source/importZoneGlobal',
        source: null,
        spotid: '99999',
        nodetype: 'Zone'
      };
      runtest(importer, function(error, result) {
        callback(error, result);
      });
    });
  });

}).call(this);

//# sourceMappingURL=test_import_nodes.js.map
