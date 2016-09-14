"use strict";

const phantom = require("phantom");
const co      = require("co");

module.exports = {
  createLineChartImg: function (args) {
    co(function*() {
      const instance = yield phantom.create();
      const page = yield instance.createPage();
      const html = '<html><head><script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script><script type="text/javascript">google.charts.load("current", {"packages":["corechart"]});</script></head><body><div id="chart"><p>test</p></div></body></html>';
      const width = 800;
      const height = 400;
      page.viewportSize = { width: width, height: height};
      page.setContent(html, "");
      page.on("onConsoleMessage", function(msg){
        //console.log(msg);
        page.render('chart.jpeg', {format: 'jpeg', quality: '100'});
        page.close();
        instance.exit();
      });
      page.on("onLoadFinished", function(){
        page.property("content").then(function(data){
          console.log("result HTML: " + JSON.stringify(data));
        });
        page.evaluate(function (args, width, height){
          google.charts.setOnLoadCallback(function (){
            console.log(JSON.stringify(google.charts));
            var data = google.visualization.arrayToDataTable(args);
    
            var options = {
              title: "Line chart of Completed task number",
              legend: 'none',
              width: width,
              height: height
            };
    
            var chart_div = document.getElementById('chart');
            var chart = new google.visualization.LineChart(chart_div);
    
            // Wait for the chart to finish drawing before calling the getImageURI() method.
            google.visualization.events.addListener(chart, 'ready', function () {
              chart_div.innerHTML = '<img src="' + chart.getImageURI() + '">';
              console.log(chart_div.innerHTML);
            });
    
            chart.draw(data, options);
          });
        }, args, width, height);
      });
    }).catch(console.error);
  }
};

