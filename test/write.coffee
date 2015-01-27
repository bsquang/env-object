write  = require '../src/write'
mkdirp = require 'mkdirp'
rimraf = require 'rimraf'
fs     = require 'fs'

# Assert that the contents of two files are equal
eqfile = (a, b) ->
  a = fs.readFileSync a, { encoding: 'utf8' }
  b = fs.readFileSync b, { encoding: 'utf8' }
  a.should.eql b

describe 'write', ->

  beforeEach (done) -> mkdirp 'temp', done

  afterEach 'cleaning temp', (done) -> rimraf 'temp', done

  it 'should write empty objects', (done) ->

    write('temp/ENV', {}).then ->
      eqfile 'temp/ENV', 'test/fixtures/ENV1'
      done()

  it 'should write plain values', (done) ->

    write('temp/ENV', { PLAIN: 'VALUE' }).then ->
      eqfile 'temp/ENV', 'test/fixtures/ENV3'
      done()

  it 'should write quoted values', (done) ->

    write('temp/ENV', { QUOTED: '$VALUE'}).then ->
      eqfile 'temp/ENV', 'test/fixtures/ENV4'
      done()

  it 'should write numeric values', (done) ->

    write('temp/ENV', { NUMBER: 1 }).then ->
      eqfile 'temp/ENV', 'test/fixtures/ENV5'
      done()

  it 'should write flag values', (done) ->

    write('temp/ENV', { FLAG: '' }).then ->
      eqfile 'temp/ENV', 'test/fixtures/ENV6'
      done()

  it 'should write exported values', (done) ->

    write('temp/ENV', { EXPORTED: 'VALUE' }, { shell: true }).then ->
      eqfile 'temp/ENV', 'test/fixtures/ENV7'
      done()

  it 'should resolve with node-style callbacks', (done) ->

    write 'temp/ENV', {}, (err, data) ->
      (err is null).should.be.true
      eqfile 'temp/ENV', 'test/fixtures/ENV1'
      done()

  it 'should reject with node-style callbacks', (done) ->

    write 'missing/file', (err, data) ->
      (err isnt null).should.be.true
      done()