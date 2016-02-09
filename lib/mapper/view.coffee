Mapper = require './index'

class ViewMapper extends Mapper
  constructor: (srcDirs, viewType) ->
    super(srcDirs: srcDirs, postfix: "views/#{viewType}", acceptedExts:['.mustache','.html'])

  loadList: (list)->
    @items = []
    @map = {}

    for item in list
      @loadItem(item)
    @preloadComplete = true

  loadItem: (item)->
    origItem = item
    for ext in @acceptedExts
      item = item.replace ext,''
    item = item.replace /\/index/,''
    @items.push item
    @map[item] = origItem


  get: (modPath, opts={})->
    res = super(modPath,opts)
    return @map[res]
  
module.exports = ViewMapper