// Generated by CoffeeScript 1.10.0
(function() {
  var Importer, config, importer;

  Importer = require('./importers/ImportFromCSV');

  config = {
    cypher: "MATCH (s:Warehouse),(c:Zone {id:'99999'}) CREATE (s)-[:LAST_MILE{ zip:'000',id:s.id+'_99999' }]->(c)"
  };

  importer = new Importer(config);

  module.exports = importer;

}).call(this);

//# sourceMappingURL=wireupWarehousesToGlobalZone.js.map
