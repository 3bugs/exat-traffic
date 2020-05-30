var express = require('express');
var app = express();
var http = require('http').createServer(app);
var io = require('socket.io')(http);

app.use(express.static('./'));

/*app.get('/', function (req, res) {
    //res.sendFile(__dirname + '/index.html');
    res.send('<h1>Socket.IO Server is Running.</h1>');
});*/

/*app.get('/connection_visualization_new.html', function (req, res) {
    res.sendFile(__dirname + '/connection_visualization_new.html');
});*/

app.get('/location', function (req, res) {
    const {lat, lng} = req.query;
    //io.emit('location', `Latitude: ${lat}, Longitude: ${lng}`);
    io.emit('location', {lat: parseFloat(lat), lng: parseFloat(lng)});
    console.log(`Latitude: ${lat}, Longitude: ${lng}`);

    res.send('ok');
});

io.on('connection', function (socket) {
    console.log('a client connected');

    /*socket.on('chat message', function (msg) {
        console.log('message: ' + msg);
        io.emit('chat message', msg);
    });

    socket.on('disconnect', function () {
        console.log('user disconnected');
    });*/
});

http.listen(3000, function () {
    console.log('listening on *:3000');
});
