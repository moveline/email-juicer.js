EmailTemplate = require '../src/email-template'

template = null
should = require 'should'

describe 'email template', ->
  describe 'with html', ->
    before ->
      template = new EmailTemplate()
      template
        .setEngine('ejs')
        .setHtml('<h1>Hi <%= user %></h1>')
        .setStyles('h1 { color: pink; }')

    it 'inlines css', (done) ->
      template.render {user: 'cgarvis'}, (err, results) ->
        results.should.have.property('html').include('color: pink')
        done()

    it 'sets variables properly', (done) ->
      template.render {user: 'cgarvis'}, (err, results) ->
        results.should.have.property('html').include('cgarvis')
        done()


  describe 'with text', ->
    before ->
      template = new EmailTemplate()
      template
        .setEngine('ejs')
        .setHtml('<h1>Hi <%= user %></h1>')
        .setText('Hi <%= user %>')

    it 'sets variables properly', (done) ->
      template.render {user: 'cgarvis'}, (err, results) ->
        results.should.have.property('text').include('cgarvis')
        done()
