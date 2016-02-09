Mapper = require './index'
Page = require '../page'
View = require '../view'
Q = require 'q'

class PageMapper extends Mapper
  constructor: (srcDirs) ->
    super(srcDirs:srcDirs, postfix:"controllers/pages", acceptedExts: ['.js','.coffee','.json'])
    View::init(srcDirs)

  serve:(req, res, next)=>
    return @serveWait(res) unless @preloadComplete

    [modPath, args] = @get(req.path)
    return next() unless modPath?

    module = require modPath
    if typeof module is 'function' and module::isPageModule
      page = new module(req, args)
      page.serve(res, next)
      return

    page = new Page(req, args)
    
    page.prepare = -> Q(module).then((res)=> @data = module )

    page.serve(res, next)
    
  serveWait: (res)->
    res.end("""
      <html>
        <head>
          <title>Initializing...</title>
        </head>
        <body>
          Initializing...
          <script>
            setTimeout(function(){
              window.location.reload()
            },2000)
          </script>
        </body>
      </html>
      """)

  get: (modPath, pageArgs=[])->
    res = super(modPath)
    return [res, pageArgs] if res?
    
    parts = modPath.split('/')

    return [null,pageArgs] if parts.length is 1 and parts[0] is ''

    pageArgs.unshift(parts.pop())

    return @get(parts.join('/'), pageArgs)
  
module.exports = PageMapper