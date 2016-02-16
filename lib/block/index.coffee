Mapper = require '../mapper'
Q = require 'q'

blocks = null

class Block
  constructor: (@path, @args)->
    # circular dependency issue fix. :)
    View = require '../view'
    @view = View::forBlock(@path, @args)

    # set externally, otherwise null
    @parent = null
    @page = null

  prepare: ()->

  render: ()->
    Q(true).then(()=>
      @prepare()
    ).then((data)=>
      @data = data
      @view.render(@, parent: @parent)
    )

Block::init = (srcDirs)->
  # TODO: Create a blockmapper class
  blocks = new Mapper(srcDirs: srcDirs, postfix: "controllers/blocks", acceptedExts:[".js",".coffee",".json"])
  blocks.preload()

Block::get = (path, args)->
  modPath = blocks.get(path, recursive: false)

  return new Block(path, args) unless modPath?

  module = require(modPath)

  return new module(path, args) if module.prototype? and module::isBlockModule
  
  block = new Block(path, args)

  if typeof module is 'function'
    block.prepare = module
  else
    block.prepare = -> module

  return block

module.exports = Block