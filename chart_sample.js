"use strict";

const phantom = require("phantom");
const co      = require("co");

co(function*() {
  const instance = yield phantom.create();
  const page = yield instance.createPage();
  const html = '<html><head><script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script><script type="text/javascript">google.charts.load("current", {"packages":["corechart"]});</script></head><body><div id="chart"><p>test</p></div></body></html>';
  page.setContent(html, "");
  page.on("onConsoleMessage", function(msg){
    console.log(msg);
    page.close();
    instance.exit();
  });
  page.on("onLoadFinished", function(){
    page.property("content").then(function(data){
      console.log("result HTML: " + JSON.stringify(data));
    });
    page.evaluate(function (){
      google.charts.setOnLoadCallback(function (){
        console.log(JSON.stringify(google.charts));
        var data = google.visualization.arrayToDataTable([
          ['Element', 'Density', { role: 'style' }],
          ['Copper', 8.94, '#b87333', ],
          ['Silver', 10.49, 'silver'],
          ['Gold', 19.30, 'gold'],
          ['Platinum', 21.45, 'color: #e5e4e2' ]
        ]);

        var options = {
          title: "Density of Precious Metals, in g/cm^3",
          bar: {groupWidth: '95%'},
          legend: 'none',
        };

        var chart_div = document.getElementById('chart');
        var chart = new google.visualization.ColumnChart(chart_div);

        // Wait for the chart to finish drawing before calling the getImageURI() method.
        google.visualization.events.addListener(chart, 'ready', function () {
          chart_div.innerHTML = '<img src="' + chart.getImageURI() + '">';
          console.log(chart_div.innerHTML);
        });

        chart.draw(data, options);
      });
    }, 10, "");
  });
}).catch(console.error);

