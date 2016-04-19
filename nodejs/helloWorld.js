var express = require('express');
var app = express();
app.use(express.static('public'));


app.get('/', function (req, res) {
  res.send('Hello !!!! world');
})
app.delete('/del_user', function(req, res){
  console.log('deleting to response /del_user');
  res.send('delete page!');
})
app.get('/ab+cd', function(req, res){
  console.log('/ab*cd request');
  res.send('response to ab*cd')
})
app.get('/abcd', function(req, res){
  console.log('/abcd request');
  res.send('response to abcd')
})




var server = app.listen(8081, function(){
  var host = server.address().address
  var port = server.address().port
  console.log('example, address is %s:%s', host, port)
})
