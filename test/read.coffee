read = require '../src/read'

describe 'read', ->

  it 'should read empty files', (done) ->

    read('test/fixtures/ENV1').then (data) ->
      data.should.eql {}
      done()

  it 'should ignore comments', (done) ->

    read('test/fixtures/ENV2').then (data) ->
      data.should.eql {}
      done()

  it 'should read plain values', (done) ->

    read('test/fixtures/ENV3').then (data) ->
      data.should.eql { PLAIN: 'VALUE' }
      done()

  it 'should read quoted values', (done) ->

    read('test/fixtures/ENV4').then (data) ->
      data.should.eql { QUOTED: '$VALUE' }
      done()

  it 'should read number values', (done) ->

    read('test/fixtures/ENV5').then (data) ->
      data.should.eql { NUMBER: '1' }
      done()

  it 'should read flag values', (done) ->

    read('test/fixtures/ENV6').then (data) ->
      data.should.eql { FLAG: '' }
      done()

  it 'should read exported values', (done) ->

    read('test/fixtures/ENV7').then (data) ->
      data.should.eql { EXPORTED: 'VALUE' }
      done()

  it 'should resolve with node-style callbacks', (done) ->

    read 'test/fixtures/ENV1', (err, data) ->
      (err is null).should.be.true
      data.should.eql {}
      done()

  it 'should reject with node-style callbacks', (done) ->

    read 'missing/file', (err, data) ->
      (err isnt null).should.be.true
      done()