// Generated by CoffeeScript 1.10.0
(function() {
  var Importer, config, importer;

  Importer = require('./importers/ImportFromCSV');

  config = {
    cypher: "MATCH (s:Product {id:line.ProductItemId}),(b:Seller {id:line.WarehouseID}) CREATE (s)- [:BELONGS_TO{ sourceId:line.SourceNodeID, inventory:line.ProductAvailability, visibility:1, id:s.id+'_'+b.id }]->(b)"
  };

  importer = new Importer(config);

  module.exports = importer;

}).call(this);

//# sourceMappingURL=wireupProductToSellers.js.map
