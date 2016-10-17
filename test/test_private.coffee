should = require('should')
assert = require('assert')
sinon = require('sinon')

describe 'Test Import From CSV With Template', () ->

    class Me

        constructor: () ->

        doit = (b) ->
            return 'b'

        Me.prototype['test_doit'] = doit

    it 'sets calls base barfer', (done) ->
        x = new Me()
        console.log(x.test_doit(1))
        done()
