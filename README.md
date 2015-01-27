env-object
=========
[![Build Status](https://travis-ci.org/atonparker/env-object.png?branch=master)](https://travis-ci.org/atonparker/env-object)

__env-object__ reads and writes environment variables. Unlike many of it's alternatives, this module does _not_ merge the parsed variables to `process.env`. It is intended to help manage the environments of other programs on the machine.

Installation
------------

`npm install --save env-object`

Usage
-------

You've got a file (_path/to/ENV_) with a bunch of environment variables in it:

    # An example environment file
    
    FOO=BAR
    NUM=123
    
    # Quotes work, if your value has reserved characters
    FIZZ="BUZZ"
    
    # Empty values work too
    FLAG=
    
    # You can also use shell syntax, so your environment variables can be
    # referenced directly by a shell script.
    export FOO=BAR

You can read it into an object:

    env = require 'env-object'
    
    env.read 'path/to/ENV', (err, data) ->
      {FOO, NUM, FIZZ, FLAG} = data 
      FOO is 'BAR'
      NUM is '123'
      FIZZ is 'BUZZ'
      FLAG? is true

You can also overwrite it with new values:

    env.write 'path/to/ENV', { KEY: VALUE }, (err) ->
      # all done!

Both functions also support promises:

    env.read 'path/to/ENV'
       .then (data) -> console.log data
       .catch (err) -> console.log err
    
    env.write 'path/to/ENV', { KEY: VALUE }
       .then -> # all done!
       .catch (err) -> console.log err

Methods
-------

#### read(filepath, callback)

Read a file of environment variables into an object. The `filepath` will be resolved in the function, so relative filepaths are supported. The `callback` is optional, and is only in case you don't want to use promises.

Returns a [Promise](https://github.com/petkaantonov/bluebird).

#### write(filepath, data, options, callback)

Write the properties of an object to a file, as environment variables. The `filepath` will be resolved in the function, so relative filepaths are supported. If `options.shell` is true, each line will start with `exports`. The options are passed through to [fs.writeFile](http://nodejs.org/api/fs.html#fs_fs_writefile_filename_data_options_callback). The `callback` is optional, and is only in case you don't want to use promises.

Returns a [Promise](https://github.com/petkaantonov/bluebird).

Testing
-------

env-object uses [Mocha](http://mochajs.org) for testing. To run the test suite, call `npm test` in the project directory.
