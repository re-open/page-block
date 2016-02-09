type1 = {
  a: 'b'
}

type2 = ()->
  a: 'b'

class type3
  constructor: () ->
type3::isPage = true

class type4 extends type3
  constructor: () ->
    # ...
  

console.log typeof type1
console.log typeof type2
console.log type4::isPage