express = require('express')
router = express.Router()
package_json = require('../package.json');

# GET home page.
router.get('/', (req, res, next) ->
    res.render('index', { title: 'Build Direct Routing Server' })
)
semantics = package_json.version.split('.')
dt1 = new Date();

datetime1 = dt1.toDateString()+' '+dt1.toTimeString()
# GET health check page.
router.get('/ping', (req, res, next) ->
    dt2 = new Date();

    datetime2 = dt2.toUTCString()

    version = {
        "version": {
            "major": semantics[0],
            "minor": semantics[1],
            "build": semantics[2]
        },
        "serviceName": "BuildDirect.RoutingService.WebApi, Version="+package_json.version,
        "utcStartDate": datetime1
        "utcRequestDate": datetime2
    }
    res.render('ping', { version: JSON.stringify(version,null,4) })
)
module.exports = router