# Module Dependencies
async = require 'async'
cons = require 'consolidate'
juice = require 'juice'

class EmailTemplate
  setEngine: (@engine) ->
    this
  setHtml: (@html) ->
    this
  setText: (@text) ->
    this
  setStyles: (@css) ->
    this

  render: (options, fn) ->
    if 'function' is typeof options
      fn = options
      options = {}


    async.parallel {
      html: async.apply @renderHtml, options
      text: async.apply @renderText, options
    }, (err, results) ->
      fn(err, results)

  renderHtml: (options, fn) =>
    if cons[@engine]?
      cons[@engine].render @html, options, (err, data) =>
        if err
          fn(err, '')
        else
          data = juice(data, @css) if @css?
          fn(null, data)
    else
      fn "Could not found engine '#{@engine}'"

  renderText: (options, fn) =>
    if cons[@engine]?
      cons[@engine].render @text, options, fn
    else
      fn "Could not found engine '#{@engine}'"

exports = module.exports = EmailTemplate
