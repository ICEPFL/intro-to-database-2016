var express = require('express')
var path = require('path')
var _ = require('lodash')
var oracledb = require('oracledb')
var config = require('../config')
var models = require('../models')
var router = express.Router()
var searching = require('../models/searchAuthor')

var ok = {
	meta: {
		state: 0,
		message: 'ok'
	},
	data: null
}

function getValidQuery(query, models) {
  var res = {}
  _.each(query, function(value, key)
	{
    if (value) {
			if (!models) {
	      res[key] = value
			}
			else {
				if (models[key] == 'string') {
					res[key] = "'" + value + "'"
				}
				else if (models[key] == 'date'){
					res[key] = 'TO_DATE('+ "'" + value + "'" +"," + "'YYYY-MM-DD'" + ')'
				}
				else {
					res[key] = value;
				}
			}
    }
  })
  return res
}
function getValidSearch(query, models) {
  var res = {}
  _.each(query, function(value, key)
	{
			key = 'author_name'
			res[key] = value;
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
	res.render('query', {entries: JSON.stringify(models[type])})

})

router.get('/query/:category', function(req, res) {
	// console.log(req)
	console.log(req.query)
	var category = req.params.category
	console.log(models[category])
  var query = getValidQuery(req.query, models[category].columns)
  console.log(query)
  var condiArr = []
	_.each(	query, function(value, key) {console.log(key); console.log(value); condiArr.push(key + ' = ' + value)} )

	var sqlStr = 'SELECT * FROM ' + category + ' WHERE ' + condiArr.join(' AND ')
	console.log('sql string: ' + sqlStr);

	router.connection.execute(
															// bind value for :id
    sqlStr, [], { outFormat: oracledb.OBJECT },

		function(err, result)
    {      if (err) { console.error('Error: ' + err.message); return; }
           console.log(result.rows);
           res.render('result_try', {results: JSON.stringify(result.rows) })
    });

})

router.get('/searchPage', function(req, res) {
  console.log(req.query)
  // var type = req.query.category
	res.render('searchAuthor', {entries: JSON.stringify(searching)})

})

router.get('/search/searchAuthor', function(req, res) {
	// console.log(req)
	// console.log('hahahahahah')
	console.log(req.query)
	var category = 'searchAuthor'
	console.log(models[category])
  var query = getValidSearch(req.query, 'models[category].columns')
	console.log('thi si query!')
  console.log(query)
  var condiArr = []
	_.each(	query, function(value, key) {console.log(key); console.log(value); condiArr.push(value)} )

	var sqlStr = 'SELECT * FROM author' + ' WHERE author_legal_name like ' + '\'' +condiArr + '\'' + ' OR author_name like ' + '\'' + condiArr + '\''
					 		+ ' OR author_last_name like ' + '\'' + condiArr + '\'' + ' OR author_last_name like ' + '\'' + condiArr + '\'' + ' OR pseudonym like ' + '\'' + condiArr + '\''
							+ ' OR birth_place like ' + '\'' + condiArr + '\''
	console.log('sql string: ' + sqlStr);

	router.connection.execute(
															// bind value for :id
    sqlStr, [], { outFormat: oracledb.OBJECT },

		function(err, result)
    {      if (err) { console.error('Error: ' + err.message); return; }
          //  console.log(result.rows);
           res.render('result_try', {results: JSON.stringify(result.rows) })
    });

})




router.get('/deletionPage', function(req, res) {
  console.log(req.query)
  var type = req.query.category
	res.render('delete', {entries: JSON.stringify(models[type])})
})

router.get('/deletion/:category', function(req, res) {
	// console.log(req)
	console.log(req.query)
	var category = req.params.category
	console.log(models[category])
  var query = getValidQuery(req.query, models[category].columns)
  console.log(query)
  var condiArr = []
	_.each(	query, function(value, key) {console.log(key); console.log(value); condiArr.push(key + ' = ' + value)} )

	var sqlStr = 'DELETE FROM ' + category + ' WHERE ' + condiArr.join(' AND ')
	console.log('sql string: ' + sqlStr);

	router.connection.execute(
															// bind value for :id
    sqlStr, [], { outFormat: oracledb.OBJECT },

		function(err, result)
    {      if (err) { console.error('Error: ' + err.message); return; }
				   console.log(result)
           console.log(result.rows);
					 console.log('testsett')
           res.render('delete_results')
    });

})









router.get('/insertionPage', function(req, res) {
  console.log(req.query)
  var type = req.query.category
	res.render('insert', {entries: JSON.stringify(models[type])})
})

router.get('/insertion/:category', function(req, res) {
	console.log(req.query)
	var category = req.params.category
	console.log(models[category])
  var query = getValidQuery(req.query, models[category].columns)
  console.log(query)
  var condiArr = []
	_.each(	query, function(value, key) {console.log(key); console.log(value); condiArr.push(value)} )
	var titles = []
	_.each(	query, function(value, key) {console.log(key); console.log(value); titles.push(key)} )

	var sqlStr = 'INSERT INTO ' + category + ' (' + titles.join(' , ') + ') ' + 'VALUES' + ' (' + condiArr.join(' , ') + ') '
	console.log('sql string: ' + sqlStr);

	router.connection.execute(
															// bind value for :id
    sqlStr, [], { outFormat: oracledb.OBJECT },

		function(err, result)
    {      if (err) { console.error('Error: ' + err.message); return; }
				   console.log(result)
           console.log(result.rows);
					 console.log('testsett')
           res.render('insert_result')
    });

})












router.get('/simpleA', function(req, res) {
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
