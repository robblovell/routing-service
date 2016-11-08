combyne = require 'combyne'
class FormatResponse
    constructor: () ->
        ###
            {
            "Content":JSON,
            "Success":Boolean
            "StatusCode":Integer
            }
        ###
        @template = { StatusCode: "String", Success: "Boolean", Contents: "String" }

    make: (code, success, response) ->
        @template.Contents = response
        @template.Success = success
        @template.StatusCode = code
        return JSON.stringify(@template)

module.exports = FormatResponse