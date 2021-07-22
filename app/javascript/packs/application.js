// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
// import "jquery"

global.$ = jQuery;

// $(document).on('turbolinks:load', function() {
    // alert("Testando o jquery!!");	
// });

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// document.addEventListener("turbolinks:before-render", function() {
//     Turbolinks.clearCache()
// })

// DataTables Config
require('datatables.net-bs4')
import './app/datatables/customDataTable.js';

// notify
window.Toastify = Toastify

// moment.js (added "environment.js")
var moment = require('moment'); // require
window.moment = moment
// global.moment = moment
moment().format();
//console.log(moment("20111031", "YYYYMMDD").fromNow());

// module to moment
var momentDurationFormatSetup = require("moment-duration-format");
momentDurationFormatSetup(moment);


