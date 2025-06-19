require! [cluster, net, \string-hash, os, events]


export class Pool extends events.EventEmitter
  ({@concurrency = process.env.CONCURRENCY or os.cpus!length, @hash = string-hash} = {}) ->

    @workers = []
      ..length = @concurrency

    @robin = 0

    process
      ..on \SIGINT, @~close
      ..on \SIGTERM, @~close
      ..on \SIGHUP, @~reload

  select: (conn, {affinity-key}) ->
    if affinity-key
      index = @hash(affinity-key) % @workers.length
    else
      index = @robin++
      @robin %= @concurrency

    index

  send: (conn, args = {}) !->
    @workers[@select(conn, args)].send args, conn

  start: !->
    @n-ready = 0
    for i til @concurrency when not @workers[i]
      @fork i

  stop: (signal = \SIGTERM) !->
    delete! @ready
    for w in @workers when w
      w.process.kill signal

  reload: !->
    @stop \SIGHUP
    @start

  close: (signal) !->
    @stop signal

  fork: (index) ->
    @workers[index] = cluster.fork!
      ..on \message, ({ns, cmd}) !~>
        when ns == \stinky and cmd == \ready
          # console.log '[%d] ready %d', Date.now(), ..id
          unless ..ready
            ..ready = true
            if not @ready and ++@n-ready == @concurrency
              @ready = true
              delete! @n-ready
              @emit \ready

      ..on \exit, (code, signal) !~>
        # console.log '[%d] worker %d: died on %s', Date.now(), ..id, signal
        @fork index unless signal in [\SIGTERM, \SIGINT]

module.exports = new Pool! <<< module.exports
