nelson = require '../lib/main'

darpOS = require 'os'
console.log darpOS.type() # -> Linux
nelson.mock 'os.type', -> 'winblows'
console.log darpOS.type() # -> winblows
nelson.restore 'os.type'
console.log darpOS.type() # -> Linux
nelson.mock 'os.type', -> 'mac 4000g steve jawbz edition'
console.log darpOS.type() # -> mac 4000g steve jawbs edition
nelson.restoreAll()
console.log darpOS.type() # -> Linux
  
darpSys = require 'sys'
systest = {tar: 'dar', dar: 'har'}
console.log darpSys.inspect systest
nelson.mock 'sys.inspect', (obj) -> 
  delete obj[key] for key in Object.keys obj when key is 'dar' # Filter out hashes when the key is dar
  return obj
    
console.log darpSys.inspect systest
nelson.restoreAll()
