express = require('express')
path = require('path')
cors = require('cors')
timeout = require('connect-timeout')

favicon = require('serve-favicon')
#logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
routes = require('./paths/index')
config = require('./config/configuration')

haltOnTimedout = (req, res, next) ->
  next() if (!req.timedout)

app = express()

# view engine setup
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'jade')

# uncomment after placing your favicon in /public
app.use(favicon(path.join(__dirname, 'public/images', 'favicon.ico')))

#app.use(logger('dev'))
app.use(cors())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(cookieParser())
app.use(require('stylus').middleware(path.join(__dirname, 'public')))
app.use(express.static(path.join(__dirname, 'public')))

app.use('/', routes)
app.use(haltOnTimedout)

config = require('./config/configuration')

mongoose = require('mongoose')
mongoose.Promise = require('bluebird')
#mongoose.connect(config.db) # connect to our database

import_= require('./models/import')
Imports = require('./controllers/imports')(app, import_.model, config)
edge= require('./models/edge')
Edges = require('./controllers/edges')(app, edge.model)
node= require('./models/node')
Nodes = require('./controllers/nodes')(app, node.model)

Resources = {
  Imports:Imports
  Edges:Edges
  Nodes:Nodes
}

swagger = require('./controllers/swagger')
swagger(app, Resources, '/api', config)

# catch 404 and forward to error handler
app.use((req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next(err)
)
app.use(haltOnTimedout)

# error handlers
# development error handler
# will print stacktrace
if (app.get('env') == 'development' or app.get('env') == 'local')
  # development error handleripho
  # will print stacktrace
  app.use((err, req, res, next) ->
    if (err?)
      res.status(err.status || 500)
      res.render('error', {
        message: err.message,
        error: err
      })
  )
  app.use(haltOnTimedout)

else
# production error handler
# no stacktraces leaked to user
  app.use((err, req, res, next) ->
    if (err?)
      res.status(err.status || 500)
      res.render('error', {
        message: err.message,
        error: {}
      })
  )
  app.use(haltOnTimedout)

# production error handler
# no stacktraces leaked to user
#app.use((err, req, res, next) ->
#  res.status(err.status || 500)
#  res.render('error', {
#    message: err.message,
#    error: {}
#  })
#)

module.exports = [app, config]