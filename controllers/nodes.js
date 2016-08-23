// Generated by CoffeeScript 1.10.0
(function() {
  var Resource, mongoose;

  mongoose = require('mongoose');

  Resource = require('resourcejs');

  module.exports = function(app, model) {
    var resource;
    resource = Resource(app, '', 'Nodes', model).patch({
      before: function(req, res, next) {
        var result, traverse;
        traverse = require('helpers/traverse');
        if (!((req.body != null) && (req.body[0] != null) && (req.body[0].op != null))) {
          result = traverse(req.body[0], '', []);
          return req.body[0] = result[0];
        }
      }
    }).get({
      before: function(req, res, next) {}
    }).put({
      before: function(req, res, next) {}
    }).post({
      before: function(req, res, next) {}
    })["delete"]({
      before: function(req, res, next) {}
    }).index({
      before: function(req, res, next) {}
    });
    return resource;
  };

}).call(this);

//# sourceMappingURL=nodes.js.map
