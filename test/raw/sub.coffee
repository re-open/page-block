class A
  constructor: () ->
    console.log 'a'

  doSomething: ()->
    console.log 'a doing something'

class B extends A
  constructor: () ->
    console.log 'b'
    super()

  doSomething:()->
    console.log 'b doing something'
    super()

b = new B
b.doSomething()

console.log [].join('/') is ''