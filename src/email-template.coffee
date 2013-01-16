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
    if @html
      @renderTemplate @html, options, (err, data) =>
        unless err
          data = juice(data, @css) if @css?
        fn(err, data)
    else
      fn null, ''

  renderText: (options, fn) =>
    if @text
      @renderTemplate @text, options, fn
    else
      fn null, ''

  renderTemplate: (template, options, fn) =>
    if cons[@engine]?
      cons[@engine].render template, options, fn
    else
      fn "Could not found engine '#{@engine}'"

exports = module.exports = EmailTemplate
