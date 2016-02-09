recursiveFileList = require '../util/file_list'
path = require 'path'
fs = require 'fs'
class Mapper
  constructor: (config) ->
    {@srcDirs, @postfix, @acceptedExts} = config
    @preloadComplete = false

  preload: ()->
    dirs = path.join(process.cwd(), dir, @postfix) for dir in @srcDirs
    return recursiveFileList(dirs, {
      extensions: @acceptedExts
    }).then((list)=>
      @loadList(list)
    ).fail(()=>
      @loadList([])
    )

  loadList: (list)->
    @items = []

    for item in list
      @loadItem(item)

    @preloadComplete = true

  loadItem: (item)->
      for ext in @acceptedExts
        item = item.replace RegExp("#{ext}$"),''
      item = item.replace /\/index/,''
      @items.push item

  get: (modPath, opts={})->
    for srcDir in @srcDirs
      fullPath = path.join(process.cwd(), srcDir, @postfix, modPath)
      if fullPath in @items
        return fullPath
    return null unless opts.forceRecheck

    for srcDir in @srcDirs
      fullPath = path.join(process.cwd(), srcDir, @postfix, modPath)

      postfixes = ['','/index']

      for pf in postfixes
        for ext in @acceptedExts
          try 
            fs.accessSync(fullPath+pf+ext, fs.R_OK)
            @loadItem(fullPath+pf+ext)
            return fullPath
          catch e
    
    return null

module.exports = Mapper