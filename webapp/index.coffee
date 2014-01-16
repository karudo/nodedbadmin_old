App = window.App = require './app.coffee'

App.SIO = require './sio.coffee'

#MODELS
_.extend App, require './models/index.coffee'


#CONTROLLERS
_.extend App, require './controllers/index.coffee'


#ROUTES
_.extend App, require './routes/index.coffee'


#VIEWS
_.extend App, require './views/index.coffee'


require './routes.coffee'




