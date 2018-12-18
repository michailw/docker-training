const express = require('express');
const app = express();

const db = require('mongoose');
db.connect("mongodb://mongo:27017");

app.get('/', function(req, res){
	res.send("Docker compose hello");
});

app.listen(80, function(){
	console.log('Node app listening on port 8080!');
});
