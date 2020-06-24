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

app.get('/api/:action',
  (req, res) => {
    const connection = mysql.createConnection({
      host: 'localhost',
      user: 'root',
      password: 'Exf@2020ch5U$m#2kh&Mc[XY',
      database: 'itsexat2020'
    });
    connection.connect();

    switch (req.params.action) {
      case 'gate_in':
        connection.query(
          'select m.route_id, temp.gate_in_id, temp.name as gate_in_name, temp.marker_id, m.name as marker_name, m.cate_id, m.lat, m.lng, m.enable, temp.cost_tolls_count from\n' +
          '(select ct.gate_in_id, gi.name, gi.marker_id, count(ct.gate_in_id) as cost_tolls_count\n' +
          'from (cost_tolls ct inner join gate_in gi on ct.gate_in_id = gi.id) \n' +
          'group by ct.gate_in_id) as temp\n' +
          'inner join markers m on temp.marker_id = m.id\n' +
          'order by m.route_id, temp.gate_in_id',
          (error, results, fields) => {
            if (error) throw error;
            res.json({
              error: {
                code : 0,
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
