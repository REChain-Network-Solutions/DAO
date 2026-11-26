/**
 * admin dashboard js
 * 
 * @package Sngine
 * @author Zamblek
 */


// read dashboard data
function admin_dashboard_data() {
  var node = document.getElementById('admin-dashboard-data');
  if (!node) {
    return null;
  }
  try {
    return JSON.parse(node.textContent);
  } catch (e) {
    return null;
  }
}


// token
function admin_dashboard_token(name) {
  return getComputedStyle(document.documentElement).getPropertyValue(name).trim();
}


// area chart
function admin_dashboard_growth(data) {
  var el = document.getElementById('admin-chart-growth');
  if (!el || typeof ApexCharts === 'undefined') {
    return;
  }
  var dark = document.documentElement.getAttribute('data-theme') === 'admin-dark';
  var months = [__['Jan'], __['Feb'], __['Mar'], __['Apr'], __['May'], __['Jun'], __['Jul'], __['Aug'], __['Sep'], __['Oct'], __['Nov'], __['Dec']];
  var chart = new ApexCharts(el, {
    chart: {
      type: 'area',
      height: 280,
      toolbar: { show: false },
      zoom: { enabled: false },
      fontFamily: 'inherit',
      background: 'transparent',
    },
    theme: { mode: dark ? 'dark' : 'light' },
    series: [
      { name: __['Users'], data: data.users },
      { name: __['Posts'], data: data.posts }
    ],
    colors: [admin_dashboard_token('--color-primary'), admin_dashboard_token('--color-info')],
    dataLabels: { enabled: false },
    stroke: { curve: 'smooth', width: 2 },
    fill: { type: 'solid', opacity: 0.12 },
    grid: {
      borderColor: admin_dashboard_token('--color-base-300'),
      strokeDashArray: 4,
      padding: { left: 8, right: 8 }
    },
    xaxis: {
      categories: months,
      axisBorder: { show: false },
      axisTicks: { show: false },
      labels: { style: { colors: admin_dashboard_token('--color-base-content') } }
    },
    yaxis: {
      min: 0,
      labels: { style: { colors: admin_dashboard_token('--color-base-content') } }
    },
    legend: {
      show: false
    },
    tooltip: { shared: true, intersect: false }
  });
  chart.render();
}


// init
var admin_dashboard = admin_dashboard_data();
if (admin_dashboard) {
  admin_dashboard_growth(admin_dashboard);
}
