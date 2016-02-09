_ = require 'underscore'

PageMapper = require './lib/mapper/page'
View = require './lib/view'
Block = require './lib/block'

module.exports = (srcDirs)->
  pageMapper = new PageMapper(srcDirs)
  pageMapper.preload()

  Block::init(srcDirs)
  View::init(srcDirs)
  
  return pageMapper.serve

module.exports.Page  = require './lib/page'
module.exports.Block = require './lib/block'