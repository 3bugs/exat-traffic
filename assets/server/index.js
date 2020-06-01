//https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-18-04

var express = require('express');
var app = express();
var http = require('http').createServer(app);
var io = require('socket.io')(http);

app.use(express.static('./'));

/*app.get('/', function (req, res) {
    //res.sendFile(__dirname + '/index.html');
    res.send('<h1>Socket.IO Server is Running.</h1>');
});*/

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/connection_visualization_new.html');
});

app.get('/location', function (req, res) {
    const {lat, lng, type} = req.query;
    if (lat == null || lng == null || type == null) {
        res.json({error: {code: 1, message: 'ส่งพารามิเตอร์มาไม่ครบ ต้องมี lat, lng, type'}});
        return;
    }

    const latValue = parseFloat(lat);
    const lngValue = parseFloat(lng);
    if (isNaN(latValue) || isNaN(lngValue)) {
        res.json({error: {code: 2, message: 'พารามิเตอร์ lat หรือ lng ไม่ใช่ตัวเลข'}});
        return;
    }
    if (latValue > 90 || latValue < -90 || lngValue > 180 || lngValue < -180) {
        res.json({error: {code: 3, message: 'ค่าของพารามิเตอร์ lat หรือ lng เกินขอบเขต (lat ต้องอยู่ในช่วง -90 ถึง 90, lng ต้องอยู่ในช่วง -180 ถึง 180)'}});
        return;
    }
    const validTypes = ['inuse', 'bg']
    if (!validTypes.includes(type.toString().toLowerCase())) {
        res.json({error: {code: 4, message: 'พารามิเตอร์ type ไม่ถูกต้อง, ต้องมีค่า inuse หรือ bg เท่านั้น'}});
        return;
    }

    console.log(`Latitude: ${lat}, Longitude: ${lng}`);
    io.emit('location', {lat: latValue, lng: lngValue, type});
    res.json({error: {code: 0, message: 'success: ยิงข้อมูล lat, lng ไปยังหน้าเว็บ Visualization สำเร็จ'}});
});

io.on('connection', function (socket) {
    console.log('client connected');

    socket.on('disconnect', function () {
        console.log('client disconnected');
    });
});

http.listen(3000, function () {
    console.log('listening on *:3000');
});
