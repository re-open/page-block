Mapper = require '../mapper'
Q = require 'q'

blocks = null

class Block
  constructor: (@path)->
    # circular dependency issue fix. :)
    View = require '../view'
    @view = View::forBlock(@path, @args)

    # set externally, otherwise null
    @parent = null
    @page = null

  prepare: ()->

  render: ()->
    Q(true).then(@prepare()).then(()=>
      @view.render(@, parent: @parent)
    )

Block::init = (srcDirs)->
  # TODO: Create a blockmapper class
  blocks = new Mapper(srcDirs: srcDirs, postfix: "controllers/block", allowedExts:[".js",".coffee",".json"])
  blocks.preload()

Block::get = (path)->
  modPath = blocks.get(path, recursive: false)

  return new Block(path) unless modPath?

  module = require(modPath)

  return new module(path) if module::isBlockModule
  
  block = new Block(path)

  if typeof module is 'function'
    block.prepare = module
  else
    block.prepare = -> module

  return block

module.exports = Block