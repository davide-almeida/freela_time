$(document).on('turbolinks:load', function() {
  if ($("#myPieChart").length) {
    // Set new default font family and font color to mimic Bootstrap's default styling
    Chart.defaults.global.defaultFontFamily = 'Nunito', '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
    Chart.defaults.global.defaultFontColor = '#858796';

    $.getJSON("dashboard.json", addData);
    // $.getJSON("app/dashboard.json", addData);

    // chart receita
    function addData(data) {

      const storage_percent_print = [];
      for (const value of Object.values(data.storage_percent)){
        storage_percent_print.push(parseFloat(value.replace(",", ".")).toFixed(2));
      }
      data.storage_percent_print = storage_percent_print;
      // console.log(data.storage_percent_print);
      return createChart(data);
    }

    // Pie Chart Example
    var ctx = document.getElementById("myPieChart");

    function createChart(data) {
      var myPieChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
          labels: ["Ocupado", "Livre"],
          datasets: [{
            // data: [70, 1.50],
            data: data.storage_percent_print,
            backgroundColor: ['#4e73df', '#1cc88a'],
            hoverBackgroundColor: ['#2e59d9', '#17a673'],
            borderColor: '#282a36',
            hoverBorderColor: "rgba(98, 114, 164, 0.4)",
          }],
          // datasets: [{
          //   data: [55, 30, 15],
          //   backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc'],
          //   hoverBackgroundColor: ['#2e59d9', '#17a673', '#2c9faf'],
          //   hoverBorderColor: "rgba(234, 236, 244, 1)",
          // }],
        },
        options: {
          maintainAspectRatio: false,
          tooltips: {
            backgroundColor: "#64677b",
            bodyFontColor: "#F8F8F2",
            borderColor: '#282a36',
            borderWidth: 1,
            xPadding: 15,
            yPadding: 15,
            displayColors: false,
            caretPadding: 10,
            //add percent symbol
            callbacks: {
              label: function(tooltipItem, data) {
                return data['labels'][tooltipItem['index']] + ': ' + data['datasets'][0]['data'][tooltipItem['index']] + '%';
              }
            }
          },
          legend: {
            display: false
          },
          cutoutPercentage: 80,
        },
      });
    }
  }
});
