require! {'../src/index': stinky, request, cluster}


function upstream listen
  require! [http, express]

  app = express!
  http = http.createServer app

  app.get '/test', (req, res) !->
    console.log 'AZAZA', '|' + req.socket.affinity-key + '|'
    res.json status: \ok, affinity-key: req.socket.affinity-key

  listen http, !->
    console.log 'listening on shit'


stinky 3000, upstream, { header: \affinity }
