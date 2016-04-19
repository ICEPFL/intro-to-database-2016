var express = require('express')
var path = require('path')
var _ = require('lodash')
var oracledb = require('oracledb')
var config = require('../config')
var authorEntries = require('../models/author')

var router = express.Router()

var ok = {
	meta: {
		state: 0,
		message: 'ok'
	},
	data: null
}

function getValidQuery(query) {
  var res = {}
  _.each(query, function(value, key) {
    if (value) {
      res[key] = value
    }
  })
  return res
}

oracledb.getConnection(config.oracledb, function(err, connection) {
  if (err) { console.error('Error: ' + err.message); return; }
  router.connection = connection
})
process.on('SIGINT',function(){
    process.exit(0);
});


router.get('/', function(req, res) {
	res.render('index', {})
})

router.get('/queryPage', function(req, res) {
  console.log(req.query)
  var type = req.query.category
  if (type == 'author') {
  	res.render('query', {entries: JSON.stringify(authorEntries)})
  }
  else if (type == 'book') {
    // TODO: add model/book.js
    // res.render('query', {entries: JSON.stringify(bookEntries)})
  }
})

router.get('/query', function(req, res) {
  console.log(req.query)
  var query = getValidQuery(req.query)
  console.log(query)
  var condiArr = []
  _.each(query, function(value, key) {
    condiArr.push(key + ' = ' + value)
  })
  console.log(condiArr.join(' AND '))
  router.connection.execute(
    'SELECT * FROM AUTHOR WHERE ' + condiArr.join(' AND '),
    [],  // bind value for :id
    { outFormat: oracledb.OBJECT },
    function(err, result)
    {
      if (err) { console.error('Error: ' + err.message); return; }
      console.log(result.rows);
      res.render('result', {results: JSON.stringify(result.rows) })
    });
})


module.exports = router
