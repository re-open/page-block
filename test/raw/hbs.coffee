handlebars = require 'handlebars'

template = handlebars.compile "Abhi {{asdf}}"


console.log template(asdf:"Hebbar")