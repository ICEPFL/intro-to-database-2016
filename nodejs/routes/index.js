var express = require('express')
var path = require('path')
var _ = require('lodash')
var oracledb = require('oracledb')
var config = require('../config')
var authorEntries = require('../models/author')
var publicEntries = require('../models/Publication')
var titleEntries = require('../models/title')
var year_numPublication = require('../models/year_numPublication')

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

process.on('SIGINT',function(){ process.exit(0); });


router.get('/', function(req, res) { res.render('index', {})});

router.get('/queryPage', function(req, res) {
  console.log(req.query)
  var type = req.query.category
	if (type == 'author') {
  	res.render('query', {entries: JSON.stringify(authorEntries)})
  }
  else if (type == 'publication') {
    res.render('query', {entries: JSON.stringify(publicEntries)})
  }
	else if (type == 'title') {
		res.render('query', {entries: JSON.stringify(titleEntries)})
	}

})

router.get('/query', function(req, res) {
	console.log(req.query)
  var query = getValidQuery(req.query)
  console.log(query)

  var condiArr = []
	_.each(	query, function(value, key) {console.log(key); console.log(value); condiArr.push(key + ' = ' + value)} )

  console.log(condiArr.join(' AND '))

	router.connection.execute(
															// bind value for :id
    'SELECT * FROM AUTHOR WHERE ' + condiArr.join(' AND '), [], { outFormat: oracledb.OBJECT },

		function(err, result)
    {      if (err) { console.error('Error: ' + err.message); return; }
           console.log(result.rows);
           res.render('result_try', {results: JSON.stringify(result.rows) })
    });

})

// router.get('/simplePage', function(req, res) {
//   console.log(req.query)
//   var type = req.query.category
// 	if (type == 'A') {
//   	res.render('simpleA');//, {entries: JSON.stringify(year_numPublication)})
//   }
// })

router.get('/simpleA', function(req, res) {
	console.log(req.category)
  var result = getValidQuery(req.category)
  //console.log(result)
	router.connection.execute(
		'SELECT DISTINCT EXTRACT(YEAR FROM P.public_date) AS Year, count(P.publication_id) AS Numb_Publication ' +
						'FROM Publication P, Publication_authors PA' +
													' WHERE P.publication_id=PA.publication_id'+
														' GROUP BY  EXTRACT(YEAR FROM P.public_date)',

		function(err, result)
    { if (err) { console.error('Error: ' + err.message); return; }
    //  console.log(result.rows);
      res.render('result_try', {results: JSON.stringify(result.rows) })
    });

})

router.get('/simpleB', function(req, res) {
	console.log(req.category)
  var result = getValidQuery(req.category)
	console.log('this is the results!!!')
  console.log(result)
	router.connection.execute(
		'SELECT A1.author_name FROM Author A1' +
				' WHERE A1.author_id IN ( SELECT A2.author_id FROM (SELECT DISTINCT PA.author_id FROM Publication_authors PA GROUP BY PA.author_id ORDER BY count(*) DESC ) A2 WHERE ROWNUM <11 )',

		function(err, result)
    { if (err) { console.error('Error: ' + err.message); return; }
      console.log(result.rows);
      res.render('result_try', {results: JSON.stringify(result.rows) })
    });

})

router.get('/simpleC', function(req, res) {
	console.log(req.category)
  var result = getValidQuery(req.category)
	console.log('this is the results!!!')
  console.log(result)
	router.connection.execute(
		'SELECT A1.AUTHOR_NAME AS YOUNGEST, A3.AUTHOR_NAME AS OLDEST'+
		' FROM (SELECT DISTINCT  A2.AUTHOR_NAME, EXTRACT(YEAR FROM A2.BIRTH_DATE) AS Years, EXTRACT (MONTH FROM A2.BIRTH_DATE) AS Months ,EXTRACT(DAY FROM A2.BIRTH_DATE)AS Days'+
		        ' FROM AUTHOR A2, Publication_authors PA, Publication P'+
		        ' WHERE A2.Author_ID = PA.author_id and PA.publication_id= P.publication_id and extract(year from P.public_date)= \'2010\' AND A2.BIRTH_DATE IS NOT NULL'+
		        ' ORDER BY Years DESC, Months DESC, Days DESC) A1,'+
		        ' (SELECT DISTINCT  A2.AUTHOR_NAME, EXTRACT(YEAR FROM A2.BIRTH_DATE) AS Years, EXTRACT (MONTH FROM A2.BIRTH_DATE) AS Months ,EXTRACT(DAY FROM A2.BIRTH_DATE)AS Days'+
		        ' FROM AUTHOR A2, Publication_authors PA, Publication P'+
		        ' WHERE A2.Author_ID = PA.author_id and PA.publication_id= P.publication_id and extract(year from P.public_date)= \'2010\' AND A2.BIRTH_DATE IS NOT NULL'+
		        ' ORDER BY Years ASC, Months ASC, Days ASC) A3 WHERE ROWNUM = 1',

		function(err, result)
    { if (err) { console.error('Error: ' + err.message); return; }
      console.log(result.rows);
      res.render('result_try', {results: JSON.stringify(result.rows) })
    });

})

// router.get('/simpleD', function(req, res) {
// 	console.log(req.category)
//   var result = getValidQuery(req.category)
// 	console.log('this is the results!!!')
//   console.log(result)
// 	router.connection.execute(
// 		'SELECT DISTINCT EXTRACT(YEAR FROM P.public_date) AS Year, count(P.publication_id) AS Numb_Publication ' +
// 						'FROM Publication P, Publication_authors PA' +
// 													' WHERE P.publication_id=PA.publication_id'+
// 														' GROUP BY  EXTRACT(YEAR FROM P.public_date)',
//
// 		function(err, result)
//     { if (err) { console.error('Error: ' + err.message); return; }
//       console.log(result.rows);
//       res.render('simpleResults', {results: JSON.stringify(result.rows) })
//     });
//
// })
//

module.exports = router
