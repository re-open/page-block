Page-block is a multi layered MCV framework for [express](http://expressjs.com/). It provides an easy way to separate logic between common elements re appearing in almost all pages and page specific contents.

### Motivation
A big web application becomes messy in express very soon. Because
* Lot of routes, managing this becomes an issue as soon as we have 15 or more routes.
* Lot of recurring presentation elements and no explicit way to handle then well.
* No easy way to integrate front-end development with back-end.

### How page-block helps
* Provides better separation of concerns for different visual parts of web application.
* Natural way to represent the elements of a web-app.
* Better separation of concerns.
* Ease of integration of front-end and back-end development.

## Usage

**Load the library**

```coffeescript
  PageBlock = require('page-block')
```
  
**Instantiate and use as a middleware in express**
The page-block library will expose a function that will take a single parameter. An array of source directories from where page-block library can load controllers and views.
```coffeescript
  app = express()
  app.use(PageBlock(['.']))
```

**Create a controller**

The controllers for pages will be loaded from `controllers/pages` from all the source directories. It uses explicit routing. That means if there is a controller `index.js` that will be used to serve route `/`. 
