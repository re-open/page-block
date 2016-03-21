View = require '../view'
Q = require 'q'

class Page
  constructor: (@req, @args) ->
    @view = View::forPage(@req.path)

    unless @view.templatePath?
      viewPath = @req.path.replace(RegExp("#{@args.join('/')}\/?$"),"").replace(/\/$/,'')
      @view = View::forPage(viewPath)
  
  prepare: ()->
    throw new Error("Data should be provided from controllers.")

  serve: (res, next)->
    # make sure we support synchronous prepares as well
    Q(true).then(=>@prepare()).then(()=>
      @view.render(@, isPage: true)
    ).then((rendered)=>
      res.end(rendered)
    ).fail((e)->
      next(e)
      throw e
    )

# to identify subclasses.
Page::isPageModule = true

module.exports = Page
