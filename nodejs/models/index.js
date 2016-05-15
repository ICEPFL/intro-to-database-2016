var author = require('./author')
var publication = require('./publication')
var publisher = require('./publisher')
var title = require('./title')
var awards = require('./awards')
var tags = require('./tags')
var language = require('./language')
var webpage = require('./webpage')
var note = require('./note')


var models = [author, publication, publisher, title, awards, tags, language, webpage, note]

var EXPORT = {}

models.forEach(function(model) {
  EXPORT[model.category] = model
})

module.exports = EXPORT
