const express = require('express');
const app = express();
const mysql = require('mysql');
const port = 3000;

app.get('/',
    (req, res) => {
        const connection = mysql.createConnection({
            host     : 'localhost',
            user     : 'root',
            password : 'Exf@2020ch5U$m#2kh&Mc[XY',
            database : 'itsexat2020'
        });
        connection.connect();
        connection.query('SELECT name FROM gate_in', function (error, results, fields) {
            if (error) throw error;

            const tableRows = results.reduce((total, row) => {
                return total += `<tr><td>${row.name}</td></tr>`;
            }, '');
            res.send(`<table>${tableRows}</table>`);
        });
        connection.end();
    }
);

app.listen(port, () => console.log(`API listening at http://localhost:${port}`));
