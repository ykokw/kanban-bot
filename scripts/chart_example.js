
Chart = require('./chart')

console.log("chart: " + JSON.stringify(Chart));
Chart.createLineChartImg([
  ['Date', 'number'],
  ['9/1', 10],
  ['9/2', 5],
  ['9/3', 6],
  ['9/4', 3],
  ['9/5', 12],
]);
