fs = require 'fs'
Q = require 'q'
_ = require 'underscore'

ViewMapper = require '../mapper/view'
RenderEngine = require '../render-engine'


blockViews = null
pageViews = null

class View
  constructor: (@templatePath, @origPath) ->

  render: (controller, opts={})->
    opts = _.defaults opts, { isPage: false }

    return "Template \"#{@origPath}\" not found." unless @templatePath?

    @template = fs.readFileSync(@templatePath).toString()
    @getBlocks(controller, opts).then((blocks)=>
      RenderEngine.render(@template, controller.data, blocks)
    )

  getBlocks: (controller, opts)->
    # resolve error of circular dependency.. :)
    Block  = require '../block'
    
    blockPaths = RenderEngine.parseBlocks(@template)

    blocks = (Block::get(blockPath.path, blockPath.args) for blockPath in blockPaths)

    promises = []

    for block in blocks
      block.parent = controller
      block.page = if opts.isPage then controller else controller.page

      promises.push block.render()

    return Q({}) if blocks.length < 1

    Q.all(promises).then((rendered)=>

      retval = {}
      idx = 0
      for block in blocks
        key = block.path + "-" + block.args.join(':')
        retval[key] = rendered[idx++]
      return retval
    )


View::init = (srcDirs)->
  blockViews = new ViewMapper(srcDirs, 'blocks')
  pageViews = new ViewMapper(srcDirs, 'pages')

  Q.all([
    blockViews.preload(),
    pageViews.preload()
  ])

View::forPage = (path)->
  new View(pageViews.get(path, forceRecheck: true), path)

View::forBlock = (path)->
  new View(blockViews.get(path, forceRecheck: true), path)


module.exports = View