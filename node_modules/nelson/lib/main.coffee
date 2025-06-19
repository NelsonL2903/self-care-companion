require('coffee-script'); # DRAMA BEGINS
cache = {}
assign = (ns, obj) ->
  glot = ns.split '.'
  str = "require('#{ glot[0] }')"
  str += "['#{ piece }']" for piece in glot[1..glot.length]
  cache[ns] = eval str unless cache[ns]
  eval str += ' = obj'
module.exports =
  mock: (ns, obj) -> assign ns, obj
  restore: (ns) -> assign ns, cache[ns]; delete cache[ns]
  restoreAll: -> module.exports.restore(ns) for ns in Object.keys cache    
