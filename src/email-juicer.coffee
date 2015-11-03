# Module Dependencies
async = require 'async'
cons = require 'consolidate'
juice = require 'juice'

class EmailTemplate

  setEngine: (@engine) ->
    @

  setHtml: (@html) ->
    @htmlFile = null
    @
  setHtmlFile: (@htmlFile) ->
    @html = null
    @

  setText: (@text) ->
    @textFile = null
    @
  setTextFile: (@textFile) ->
    @text = null
    @

  setStyles: (@css) ->
    @

  render: (options, fn) ->
    if 'function' is typeof options
      fn = options
      options = {}

    async.parallel {
      html: async.apply @renderHtml, options
      text: async.apply @renderText, options
    }, (err, results) ->
      fn err, results

  renderHtml: (options, fn) =>
    handleResults = (err, data) =>
      unless err
        data = juice(data, {extraCss: @css, applyStyleTags: true, preserveImportant: true}) if @css?
      fn err, data

    if @html?
      @renderTemplate @html, options, handleResults
    else if @htmlFile?
      @renderTemplateFromFile @htmlFile, options, handleResults
    else
      fn null, ''

  renderText: (options, fn) =>
    if @text?
      @renderTemplate @text, options, fn
    else if @textFile?
      @renderTemplateFromFile @textFile, options, fn
    else
      fn null, ''

  renderTemplate: (template, options, fn) =>
    try
      if cons[@engine]?
        cons[@engine].render template, options, fn
      else
        fn "Could not find engine '#{@engine}'"
    catch ex
      fn ex

  renderTemplateFromFile: (templateFile, options, fn) =>
    try
      if cons[@engine]?
        cons[@engine] templateFile, options, fn
      else
        fn "Could not find engine '#{@engine}'"
    catch ex
      fn ex

exports = module.exports = EmailTemplate
