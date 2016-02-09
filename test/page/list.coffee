PageMapper = require '../../lib/page/mapper'

loadList = ()->
  pm = new PageMapper
  pm.loadControllerList([
    'a/index.coffee'
    'a/b.coffee'
    'a/b/c.coffee'
    'a/b/c/index.coffee'
  ]);

  pm.controllers[0].should.eql('a')
  pm.controllers[1].should.eql('a/b')
  pm.controllers[2].should.eql('a/b/c')
  pm.controllers[3].should.eql('a/b/c')

mapDeep = ()->
  pm = new PageMapper
  pm.loadControllerList([
    'a/index.coffee'
    'a/b.coffee'
    'a/b/c.coffee'
    'a/b/c/index.coffee'
  ]);

  pm.controllerModuleFor('a').should.eql('a')
  pm.controllerModuleFor('a/a').should.eql('a')
  pm.controllerModuleFor('a/a/b').should.eql('a')

  pm.controllerModuleFor('a/b').should.eql('a/b')
  pm.controllerModuleFor('a/b/b').should.eql('a/b')
  pm.controllerModuleFor('a/b/b/c').should.eql('a/b')

  pm.controllerModuleFor('a/b/c').should.eql('a/b/c')
  pm.controllerModuleFor('a/b/c/d').should.eql('a/b/c')

  (pm.controllerModuleFor('b/c/d') == null).should.be.ok

describe 'Page Mapper', ->
  it 'should load the controller list with neccessary modifications', loadList
  it 'Should map request to the deepest controller possible', mapDeep