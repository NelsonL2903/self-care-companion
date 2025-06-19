**Nelson is a lightweight NodeJS mocking library** ![huhuhuhu](http://i.imgur.com/7DEce.png)


## Installation

To install nelson, use [npm](http://github.com/isaacs/npm):

        $ npm install nelson

## Usage

```javascript
var nelson = require('nelson');
nelson.mock('namespace', {thisis: 'mynewvalue'});
// Use super cool new value
nelson.restore('namespace');
// or you can use
nelson.restoreAll();
```
## Examples

```coffee-script
nelson = require 'nelson'
darpSys = require 'sys'
systest = {tar: 'dar', dar: 'har'}
console.log darpSys.inspect systest # {tar: 'dar', dar: 'har'}
nelson.mock 'sys.inspect', (obj) -> 
  delete obj[key] for key in Object.keys obj when key is 'dar' # Filter out hashes when the key is dar
  return obj
    
console.log darpSys.inspect systest # {tar: 'dar',}
nelson.restoreAll()
```
You can view further examples in the [example folder.](https://github.com/wearefractal/nelson/tree/master/examples)

## Namespacing

```'os.types.blah.blah' = require('os').types.blah.blah```

You can go as deep as you want (unlike inception)

## LICENSE

(MIT License)

Copyright (c) 2011 Fractal <contact@wearefractal.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

