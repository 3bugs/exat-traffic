const express = require('express');
const app = express();
const port = 3000;

app.get('/',
    (req, res) => res.send('Hello Node.JS !')
);

app.listen(port, () => console.log(`API listening at http://localhost:${port}`));
