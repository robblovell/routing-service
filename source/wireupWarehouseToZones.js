// Generated by CoffeeScript 1.10.0
(function() {
  var Importer, config, importer;

  Importer = require('./importers/ImportFromCSV');

  config = {
    cypher: "MATCH (s:Satellite {id:line.ExternalLocationKey}),(b:Zone {id:line.RadiusZipId}) CREATE (s)-[:LAST_MILE{ id:s.id+'_'+line.RadiusZipId, zip:line.RadiusZip }]->(b)"
  };

  importer = new Importer(config);

  module.exports = importer;

}).call(this);

//# sourceMappingURL=wireupWarehouseToZones.js.map
