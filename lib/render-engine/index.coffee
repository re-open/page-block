_ = require 'underscore'
Handlebars = require 'handlebars'

Mapper = require '../mapper'

Block = require '../block'

RenderEngine = {
  parseBlocks: (template)->
    parsed = Handlebars.parse(template)
    blocks = []

    for item in parsed.body
      if item.path? and item.path.original is 'block'
        continue if not(item.params?) or item.params.length < 1

        path = item.params.shift().original

        args = _.pluck item.params, 'original'

        blocks.push path: path, args: args

    return blocks

  render: (template, data, blocks)->
    Handlebars.unregisterHelper('block')

    Handlebars.registerHelper 'block', ()->
      
      args = _.values(arguments)
      blockData = args.pop()
      path = args.shift()

      key = path + "-" + args.join(':')
      
      return blocks[key]

    renderFn = Handlebars.compile(template)
    renderFn(data)
}

module.exports = RenderEngine