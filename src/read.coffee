Promise = require 'bluebird'
path    = require 'path'
fs      = require 'fs'
lo      = require 'lodash'

readFile = Promise.promisify fs.readFile

# Reads the ENV file at the filepath, and parses it into an object.
#
# filepath - The path to the ENV file
# callback - An optional node-style callback function
#
# Returns a {Promise}.
module.exports = (filepath, ..., callback) ->

  filepath = path.resolve filepath

  readFile filepath, { encoding: 'utf8' }

    # Split the file into lines.
    .then (string) -> string.split '\n'

    # Parse the key and value out of each line.
    .map (line) ->
      [all, key, value] = line.match(/(?:export )?(.*)="?([^"]*)"?/) or []
      if key? then return [key, value] else return null

    # Filter out any lines that the parse function couldn't understand.
    .filter (data) -> data?

    # Reduce the keys and values into an object.
    .then (pairs) ->
      pile = {}
      pile[key] = value for [key, value] in pairs
      return pile

    # This will only resolve to the callback if it is defined.
    .nodeify callback
