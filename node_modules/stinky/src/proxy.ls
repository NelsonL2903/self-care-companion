require! {'./pool': pool, net, events}

export class Proxy extends events.EventEmitter
  (@port, { @pool = pool, @header = false } = {}) ->

  make-server-fn: ->
    header =
      | typeof! @header == \String => @header
      | @header => \x-forwarded-for
      | otherwise => false

    if @header
      templ = //\r\n#header:\s*(.*?)\s*\r\n//i

      (conn) !~>
        conn.once \data, (data) !~>
          conn.pause!

          data .= to-string \ascii

          affinity-key = templ.exec data ?.1 or conn.remote-address

          @send-hit conn, affinity-key, { data }

        conn.resume!
    else
      (conn) !~> @send-hit conn, conn.remote-address

  send-hit: (conn, affinity-key, args = {}) !->
    @pool.send conn, {...args, affinity-key, ns: \stinky, cmd: \hit, port: @port}

  listen: (callback) !->
    throw new Error 'Already running' if @server

    callback ?= !-> console.log "stinky proxy ready on #{@port}"

    callback .= bind @

    @server = net.create-server { +pause-on-connect }, @make-server-fn!
      ..listen @port, !~>
        @port = @server.address!port
        if @pool.ready
          callback!
        else
          @pool.once \ready, callback

  close: ->
    (delete @server).close! if @server
