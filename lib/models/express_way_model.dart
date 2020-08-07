import 'package:flutter/material.dart';

class ExpressWayModel {
  ExpressWayModel({
    @required this.id,
    @required this.name,
    @required this.index,
    @required this.imageUrl,
    @required this.chunkData,
    this.image,
  });

  final int id;
  final String name;
  final int index; // เอาไว้ map ข้อมูล chunk เพราะ id สายทางไม่ตายตัว ขึ้นกับภาษา
  final String imageUrl;
  final List chunkData;
  final AssetImage image;

  factory ExpressWayModel.fromJson(Map<String, dynamic> json, int index) {
    return ExpressWayModel(
      id: json['id'],
      name: json['name'],
      index: index,
      imageUrl: json['cover'],
      chunkData: _chunkDataList[index],
      image: _getMockedAssetImage(index), // mocked
    );
  }

  @override
  String toString() {
    return 'ID: ${this.id}, Name: ${this.name}, ImageUrl: ${this.imageUrl}';
  }

  static AssetImage _getMockedAssetImage(int index) {
    switch (index) {
      case 0:
        return AssetImage('assets/images/home/express_way_chalerm.jpg');
      case 1:
        return AssetImage('assets/images/home/express_way_chalong.jpg');
      case 2:
        return AssetImage('assets/images/home/express_way_burapa.jpg');
      case 3:
        return AssetImage('assets/images/home/express_way_srirach.jpg');
      case 4:
        return AssetImage('assets/images/home/express_way_kanchana.jpg');
      case 5:
        return AssetImage('assets/images/home/express_way_udorn.jpg');
      case 6:
        return AssetImage('assets/images/home/express_way_bangna.jpg');
    }
    return null;
  }
}

List _chunkDataList = [
  {
    "algRouteId": 1,
    "legs": [
      {
        "origin": "ดินแดง",
        "destination": "ดาวคะนอง",
        "chunkIdList": [117, 459, 118, 120, 108, 457, 456, 127, 442, 128, 445, 443, 129],
        "pointIdList": [
          213,
          215,
          219,
          220,
          1358,
          1360,
          1361,
          1362,
          214,
          221,
          222,
          216,
          223,
          224,
          226,
          1363,
          1364,
          1365,
          1961,
          225,
          1370,
          217,
          1412,
          1413,
          1414,
          1415,
          1416,
          1417,
          1418,
          1419,
          1421,
          1422,
          1420,
          1423,
          1424,
          1425,
          1426,
          1427,
          1429,
          1430,
          1428,
          1431,
          1432,
          1433,
          1434,
          1435,
          1436,
          1437,
          1438,
          1439,
          1440,
          1441,
          1442,
          1443,
          1444,
          1445
        ]
      },
      {
        "origin": "ดินแดง",
        "destination": "บางนา",
        "chunkIdList": [
          117,
          459,
          118,
          120,
          108,
          120,
          457,
          456,
          112,
          448,
          446,
          113,
          451,
          114,
          319,
          84
        ],
        "pointIdList": [
          213,
          215,
          219,
          220,
          1358,
          1360,
          1361,
          1362,
          214,
          221,
          222,
          216,
          223,
          224,
          226,
          1363,
          1364,
          1365,
          1961,
          216,
          223,
          224,
          226,
          1363,
          1364,
          1365,
          225,
          1370,
          217,
          185,
          186,
          205,
          206,
          1338,
          1339,
          1340,
          1341,
          187,
          209,
          1342,
          1343,
          208,
          188,
          210,
          1344,
          1345,
          1346,
          1347,
          1348,
          2251,
          664,
          665,
          666,
          667,
          1948,
          1949,
          1950,
          1951,
          1952,
          1953,
          1954,
          1955
        ]
      },
      {
        "origin": "บางนา",
        "destination": "ดาวคะนอง",
        "chunkIdList": [85, 500, 125, 450, 126, 447, 449, 127, 442, 128, 445, 443, 129],
        "pointIdList": [
          668,
          669,
          670,
          671,
          1956,
          1957,
          1958,
          1959,
          1960,
          1962,
          1963,
          1964,
          2252,
          1398,
          1399,
          1400,
          1401,
          1402,
          1403,
          1404,
          2253,
          1408,
          1405,
          1406,
          1407,
          1409,
          1411,
          1410,
          1412,
          1413,
          1414,
          1415,
          1416,
          1417,
          1418,
          1419,
          1421,
          1422,
          1420,
          1423,
          1424,
          1425,
          1426,
          1427,
          1429,
          1430,
          1428,
          1431,
          1432,
          1433,
          1434,
          1435,
          1436,
          1437,
          1438,
          1439,
          1440,
          1441,
          1442,
          1443,
          1444,
          1445
        ]
      },
      {
        "origin": "บางนา",
        "destination": "ดินแดง",
        "chunkIdList": [85, 500, 125, 450, 126, 447, 449, 127, 122, 455, 458, 454, 123, 119, 124],
        "pointIdList": [
          668,
          669,
          670,
          671,
          1956,
          1957,
          1958,
          1959,
          1960,
          1962,
          1963,
          1964,
          2252,
          1398,
          1399,
          1400,
          1401,
          1402,
          1403,
          1404,
          2253,
          1408,
          1405,
          1406,
          1407,
          1409,
          1411,
          1410,
          1412,
          1413,
          1414,
          1415,
          1416,
          1417,
          1418,
          1419,
          1421,
          1422,
          1372,
          1373,
          1374,
          1375,
          1376,
          1371,
          1369,
          1378,
          1377,
          1380,
          1379,
          1381,
          1382,
          1383,
          1384,
          1385,
          1386
        ]
      },
      {
        "origin": "ดาวคะนอง",
        "destination": "ดินแดง",
        "chunkIdList": [110, 440, 444, 111, 441, 112, 122, 455, 458, 454, 123, 119, 124],
        "pointIdList": [
          183,
          184,
          192,
          195,
          196,
          197,
          198,
          199,
          1331,
          1332,
          1333,
          1334,
          1335,
          201,
          200,
          202,
          203,
          1337,
          204,
          185,
          186,
          205,
          206,
          1338,
          1339,
          1340,
          1372,
          1373,
          1374,
          1375,
          1376,
          1371,
          1369,
          1378,
          1377,
          1380,
          1379,
          1381,
          1382,
          1383,
          1384,
          1385,
          1386
        ]
      },
      {
        "origin": "ดาวคะนอง",
        "destination": "บางนา",
        "chunkIdList": [110, 440, 444, 111, 441, 112, 448, 446, 113, 451, 114, 319, 84],
        "pointIdList": [
          183,
          184,
          192,
          195,
          196,
          197,
          198,
          199,
          1331,
          1332,
          1333,
          1334,
          1335,
          201,
          200,
          202,
          203,
          1337,
          204,
          185,
          186,
          205,
          206,
          1338,
          1339,
          1340,
          1341,
          187,
          209,
          1342,
          1343,
          208,
          188,
          210,
          1344,
          1345,
          1346,
          1347,
          1348,
          2251,
          664,
          665,
          666,
          667,
          1948,
          1949,
          1950,
          1951,
          1952,
          1953,
          1954,
          1955
        ]
      }
    ]
  },
  {"algRouteId": 3, "legs": []},
  {"algRouteId": 6, "legs": []},
  {"algRouteId": 5, "legs": []},
  {"algRouteId": 10, "legs": []},
  {"algRouteId": 7, "legs": []},
  {"algRouteId": 4, "legs": []}
];
