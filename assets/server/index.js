//https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-18-04

var express = require('express');
var app = express();
var http = require('http').createServer(app);
var io = require('socket.io')(http);
const mysql = require('mysql');

app.use(express.static('./'));

/*app.get('/', function (req, res) {
    //res.sendFile(__dirname + '/index.html');
    res.send('<h1>Socket.IO Server is Running.</h1>');
});*/

/*app.get('/demo', function (req, res) {
    res.sendFile(__dirname + '/connection_visualization_new.html');
});*/

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

app.get('/api/:item/:id',
  (req, res) => {
    const connection = mysql.createConnection({
      host: 'localhost',
      user: 'root',
      password: 'Exf@2020ch5U$m#2kh&Mc[XY',
      database: 'itsexat2020'
    });
    connection.connect();

    switch (req.params.item) {
      case 'gate_in':
        const whereClause = req.params.id == null ? 'true' : `gi.route_id = ${req.params.id}`;
        connection.query(
          `SELECT temp.route_id AS gate_in_route_id, 
                    temp.gate_in_id,
                    temp.name AS gate_in_name,
                    temp.marker_id,
                    m.route_id as marker_route_id,
                    m.name AS marker_name,
                    m.cate_id,
                    m.lat,
                    m.lng,
                    m.enable,
                    temp.cost_tolls_count
             FROM (
                 SELECT gi.route_id, ct.gate_in_id, gi.name, gi.marker_id, COUNT(ct.gate_in_id) AS cost_tolls_count
                   FROM cost_tolls ct
                            INNER JOIN gate_in gi ON ct.gate_in_id = gi.id 
                   WHERE ${whereClause} 
                   GROUP BY ct.gate_in_id) AS temp
                      INNER JOIN markers m ON temp.marker_id = m.id
             ORDER BY m.route_id, temp.gate_in_id`,
          (error, results, fields) => {
            if (error) throw error;
            res.json({
              error: {
                code: 0,
                message: 'ok',
              },
              data_list: results,
            });
          });
        connection.end();
        break;
    }
  }
);

http.listen(3000, function () {
  console.log('listening on *:3000');
});
