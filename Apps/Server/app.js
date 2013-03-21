// Modules
var http = require('http');

// JSON data
var bathtubData = {
	cold_water: 10,
	cold_water_flow_max: 0.2,
	hot_water: 50,
	hot_water_flow_max: 0.16,
	bathtub_water_amount_max: 150
}

// JSON header
var headers = {
  'Content-Type': 'application/json'
};

// Setup HTTP server
var server = http.createServer(function (request, response) {
  response.writeHead(200, headers);
  response.end(JSON.stringify(bathtubData));
});

// Start server
server.listen(3000);