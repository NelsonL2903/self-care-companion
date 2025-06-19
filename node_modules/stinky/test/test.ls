require! {'../src/index': stinky, request, cluster, child_process, assert}


suite 'Fuck'

test 'app', (done) !->
  child_process.spawn './node_modules/.bin/lsc', ['./test/app.ls']
  <-! set-timeout _, 3000
  request.get "http://localhost:3000/test", {headers: {Affinity: \sucj}}, (e, r, body) !->
    throw e if e
    body = JSON.parse body
    assert.equal body.status, \ok
    done!
