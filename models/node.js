// Generated by CoffeeScript 1.10.0
(function() {
  var Mongoose, NodeSchema, Schema;

  Mongoose = require('mongoose');

  Schema = require('mongoose').Schema;

  NodeSchema = new Schema({
    id: String,
    type: String
  }, {
    strict: false
  });

  module.exports = {
    model: Mongoose.model("Node", NodeSchema),
    schema: NodeSchema
  };

}).call(this);

//# sourceMappingURL=node.js.map
