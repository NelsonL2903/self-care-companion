require! cluster


switch
when cluster.is-master

  export {Proxy} = require './proxy'
  export {Pool} = pool = require './pool'

  export setup = (port, upstream, options, callback) ->
    options = options! if options instanceof Function

    pool.start!

    new Proxy port, options
      ..listen callback


when cluster.is-worker

  export {Gateway} = require './gateway'

  export setup = (port, upstream) ->
    upstream (server, callback) !->
      new Gateway server, port
        ..listen callback


module.exports = setup <<< module.exports
