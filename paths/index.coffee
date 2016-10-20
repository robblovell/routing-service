express = require('express')
router = express.Router()
package_json = require('../package.json');

# GET home page.
router.get('/', (req, res, next) ->
    res.render('index', { title: 'Build Direct Routing Server' })
)
semantics = package_json.version.split('.')

# GET health check page.
router.get('/ping', (req, res, next) ->
    dt = new Date();

    datetime = dt.toDateString()+dt.toTimeString()
    version = {
        "version": {
            "major": semantics[0],
            "minor": semantics[1],
            "build": semantics[2]
        },
        "serviceName": "BuildDirect.RoutingService.WebApi, Version="+package_json.version,
        "utcBuildDate": datetime
    }
    res.render('ping', { version: JSON.stringify(version,null,4) })
)
module.exports = router