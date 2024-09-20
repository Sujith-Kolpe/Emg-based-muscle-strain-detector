const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

let sensorData1 = {};
let sensorData2 = {};

app.use(bodyParser.json());
app.use(express.static('public'));

app.post('/data', (req, res) => {
  const { port, emg, bpm } = req.body;

  if (port === 1) {
    sensorData1 = { emg, bpm };
  } else if (port === 2) {
    sensorData2 = { emg, bpm };
  }

  console.log(`Received data on port ${port}:`, req.body);
  res.sendStatus(200);
});

app.get('/data', (req, res) => {
  res.json({ port1: sensorData1, port2: sensorData2 });
});

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});