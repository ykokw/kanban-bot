"use strict";

const Chart = require('./chart');
const request = require('request');
const fs = require('fs');

console.log("chart: " + JSON.stringify(Chart));
Chart.createLineChartImg([
  ['Date', 'number'],
  ['9/1', 10],
  ['9/2', 5],
  ['9/3', 6],
  ['9/4', 3],
  ['9/5', 12],
]);

/*
var formData = {
  token: "SLACK_TOKEN",
  filename: "chart.jpeg",
  file: fs.createReadStream(__dirname + '/chart.jpeg'),
  channels: "#general"
};
request.post({url:'https://slack.com/api/files.upload', formData: formData}, function optionalCallback(err, httpResponse, body) {
  if (err) {
    return console.error('upload failed:', err);
  }
  console.log('Upload successful!  Server responded with:', body);
});
*/
