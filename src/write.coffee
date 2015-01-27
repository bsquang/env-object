Promise = require 'bluebird'
path    = require 'path'
fs      = require 'fs'
lo      = require 'lodash'

writeFile = Promise.promisify fs.writeFile

# Writes an object to an ENV file at the filepath.
#
# filepath - The path to the ENV file
# data     - The {Object} to write
# options  - The options (will be passed through to fs.writeFile)
#            :shell - If true, each declaration will be prepended with "export"
#                     so it can be sourced in a shell script
# callback - An optional node-style callback function
#
# Returns a {Promise}.
module.exports = (filepath, data, options = {}, ..., callback) ->

  options = lo.defaults options, { shell: false }
  {shell} = options

  filepath = path.resolve filepath

  Promise.resolve (lo.pairs data)

    # Print each key/value pair to a line.
    .map (pair) ->
      [key, value] = pair
      value = value.toString()
      if (value.match /[^\w\d_]/) then value = "\"#{value}\"" # handle reserved characters
      if shell then return "export #{key}=#{value}" else return "#{key}=#{value}"

    # Write all of the lines into a string, with an ending newline.
    .then (lines) ->
      string = lines.join('\n') + '\n'
      writeFile filepath, string, options

    # This will only resolve to the callback if it is defined.
    .nodeify callback