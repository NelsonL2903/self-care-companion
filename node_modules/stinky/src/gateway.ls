require! cluster


export class Gateway
  (@server, @port) ->

  listen: (callback) !->
    cluster.worker.on \message, ({ns, cmd, port, data, affinity-key}, conn) !~>
      if conn and port == @port and ns == \stinky and cmd == \hit
        conn
          ..affinity-key = affinity-key if affinity-key
          ..push data if data
          @server.emit \connection, ..
          ..resume!

    @server.listen 0, 'localhost', !~>
      callback.apply @, arguments if callback
      cluster.worker.send {ns: \stinky, cmd: \ready, port: @port}

  close: !->
    @server.close!
