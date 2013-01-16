EmailTemplate = require '../src/email-template'

template = null
should = require 'should'

describe 'email', ->
  html = text = ''

  before (done) ->
    template = new EmailTemplate()
    template
      .setEngine('ejs')
      .setHtml('<h1>Hi <%= user %></h1>')
      .setStyles('h1 { color: pink; }')
      .setText('Hi <%= user %>')
      .render {user: 'cgarvis'}, (err, bodies) ->
        html = bodies.html
        text = bodies.text
        done(err)

  describe 'html version', ->
    it 'inlines css', ->
      html.should.include('color: pink')

    it 'sets variables properly', ->
      html.should.include('cgarvis')

  describe 'text version', ->
    it 'sets variables properly', ->
      text.should.include('cgarvis')
