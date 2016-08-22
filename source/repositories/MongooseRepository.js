// Generated by CoffeeScript 1.10.0
(function() {
  var RestRepository, async, request;

  async = require('async');

  request = require('superagent');

  module.exports = RestRepository = (function() {
    function RestRepository(config, model1) {
      this.config = config;
      this.model = model1;
      this.buffer = null;
    }

    RestRepository.prototype.find = function(query, callback) {
      this.model.find(query, callback);
    };

    RestRepository.prototype.get = function(id, callback) {
      this.model.findById(id, callback);
    };

    RestRepository.prototype.add = function(json, callback) {
      var model;
      model = new this.model(json);
      callback(null, model);
    };

    RestRepository.prototype.set = function(id, json, callback) {
      var make;
      make = function(url, json) {
        return function(callback) {
          this.model.update({
            _id: id
          }, json, {
            multi: false
          }, callback);
        };
      };
      if ((this.buffer != null) || (callback == null)) {
        this.buffer.push(make(this.config.url, json));
      } else {
        this.model.update({
          _id: id
        }, json, {
          multi: false
        }, callback);
      }
    };

    RestRepository.prototype["delete"] = function(id, callback) {
      this.model.remove({
        _id: id
      }, callback);
    };

    RestRepository.prototype.pipeline = function() {
      this.buffer = [];
    };

    RestRepository.prototype.exec = function(callback) {
      async.parallelLimit(this.buffer, 10, (function(_this) {
        return function(error, results) {
          if ((error != null)) {
            console.log("Error:" + error);
          }
          _this.buffer = null;
        };
      })(this));
    };

    return RestRepository;

  })();

}).call(this);

//# sourceMappingURL=MongooseRepository.js.map
