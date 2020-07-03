//https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-18-04

const express = require('express');
const app = express();
const http = require('http').createServer(app);
const io = require('socket.io')(http);
const mysql = require('mysql');

const CODE_FAILED = 1;
const CODE_SUCCESS = 0;

app.use(express.static('./'));

// Add headers
app.use(function (req, res, next) {

  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', 'http://localhost:8080');

  // Request methods you wish to allow
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

  // Request headers you wish to allow
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');

  // Set to true if you need the website to include cookies in the requests sent
  // to the API (e.g. in case you use sessions)
  res.setHeader('Access-Control-Allow-Credentials', true);

  // Pass to next layer of middleware
  next();
});

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

app.get('/api/:item/:id?',
  (req, res) => {
    const connection = mysql.createConnection({
      host: 'localhost',
      user: 'root',
      password: 'Exf@2020ch5U$m#2kh&Mc[XY',
      database: 'itsexat2020'
    });
    connection.connect();

    /*connection.connect(function(err) {
      if (err) {
        res.json({
          error: {
            code: 1,
            message: 'เกิดข้อผิดพลาดในการเชื่อมต่อฐานข้อมูล',
          },
          data_list: null,
        });
        return;
      }
      console.log('connected as id ' + connection.threadId);
    });*/

    switch (req.params.item) {
      case 'gate_in':
        const whereClause = req.params.id == null ? 'true' : `gi.route_id = ${req.params.id}`;
        connection.query(
          `SELECT temp.route_name, 
                    temp.route_id AS gate_in_route_id, 
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
                 SELECT gi.route_id, r.name AS route_name, ct.gate_in_id, gi.name, gi.marker_id, COUNT(ct.gate_in_id) AS cost_tolls_count
                   FROM cost_tolls ct
                            INNER JOIN gate_in gi ON ct.gate_in_id = gi.id 
                            INNER JOIN routes r ON gi.route_id = r.id
                   WHERE ${whereClause} 
                   GROUP BY ct.gate_in_id) AS temp
                      INNER JOIN markers m ON temp.marker_id = m.id
             ORDER BY temp.route_id, temp.gate_in_id`,
          (error, results, fields) => {
            if (error) {
              res.json({
                error: {
                  code: CODE_FAILED,
                  message: 'เกิดข้อผิดพลาดในการดึงข้อมูล',
                },
                data_list: null,
              });
            } else {
              res.json({
                error: {
                  code: CODE_SUCCESS,
                  message: 'ok',
                },
                data_list: results,
              });
            }
          });
        connection.end();
        break;

      case 'cost_toll_by_gate_in':
        connection.query(
          `SELECT ct.id,
                    m.name,
                    m.lat,
                    m.lng,
                    m.cate_id,
                    m.route_id,
                    r.name AS route_name,
                    ct.part_toll,
                    ct.cost_less4,
                    ct.cost_4to10,
                    ct.cost_over10
             FROM cost_tolls ct
                      INNER JOIN markers m ON ct.marker_id = m.id
                      INNER JOIN routes r ON m.route_id = r.id 
             WHERE ct.gate_in_id = ${req.params.id} 
             ORDER BY route_id`,
          (error, results, fields) => {
            if (error) {
              res.json({
                error: {
                  code: CODE_FAILED,
                  message: 'เกิดข้อผิดพลาดในการดึงข้อมูล',
                },
                data_list: null,
              });
              connection.end();
            } else {
              results['part_toll_list'] = [];

              if (results['part_toll'] != null) {
                const partTollList = results['part_toll'].split('-');
                const partTollListCsv = partTollList.reduce(
                  (total, partToll) => total == null ? partToll : `${total}, ${partToll}`,
                  null
                );

                const sql = `SELECT *
                             FROM markers
                             WHERE id IN (${partTollListCsv})`;
                connection.query(
                  sql,
                  (error, partTollResults, fields) => {
                    if (error) {
                      res.json({
                        error: {
                          code: CODE_FAILED,
                          message: 'เกิดข้อผิดพลาดในการดึงข้อมูล',
                        },
                        data_list: null,
                      });
                      connection.end();
                      return;
                    } else {
                      results['part_toll_list'] = partTollResults;
                    }
                  }
                );
              }

              res.json({
                error: {
                  code: CODE_SUCCESS,
                  message: 'ok',
                },
                data_list: results,
              });
              connection.end();
            }
          });
        //connection.end();
        break;
    }
  }
);

http.listen(3000, function () {
  console.log('listening on *:3000');
});
