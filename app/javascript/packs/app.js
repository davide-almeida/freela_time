
import 'app/jquery/jquery.min.js';
import 'app/bootstrap/js/bootstrap.bundle.min.js';
import 'app/jquery-easing/jquery.easing.min.js';
import './app/sb-admin-2.js';
import './app/charts.js';
import '@fortawesome/fontawesome-free/js/all';
import './app/timer';
import './app/cleave';
import 'jquery-mask-plugin'


// Enable tooltips
$(document).on('turbolinks:load', function() {
// $( document ).ready(function() {
    //     if ($("#myAreaChart").length) {
    //         myCharts.start();
    //     }
    $(function () {
        $('[data-toggle="tooltip"]').tooltip()
    })

    // TIMER start (hide buttons)
    if ($("#time").length) {
        start_timer();
    }

    // second select load - dashboard page (task_scheduler form)
    if ($('#timerModal').length) {
        // company select
        if ($('select#task_schedule_project_id').length) {
            $(function() {
                $("select#task_schedule_company_id").on("change", function() {
                    $.ajax({
                        url:  "/app/dashboard/filter_projects_by_company",
                        type: "GET",
                        data: { selected_company: $("select#task_schedule_company_id").val() }
                    });
                });
            });
            // value default select tasks
            $('#task_schedule_task_id').append($("<option disabled selected hidden></option>").attr("value","").text('Você deve selecionar uma empresa'));
        }

        // project select
        if ($('select#task_schedule_task_id').length) {
            $(function() {
                $("select#task_schedule_project_id").on("change", function() {
                    $.ajax({
                        url:  "/app/dashboard/filter_tasks_by_project",
                        type: "GET",
                        data: { selected_project: $("select#task_schedule_project_id").val() }
                    });
                    
                });
            });
        }
    }

    // second select load - tasks page
    if ($('#task_new').length) {
        if ($('select#task_project_id').length) {
            // function request
            function request_task() {
                $.ajax({
                    url:  "/app/task_select/filter_projects_by_company",
                    type: "GET",
                    data: { selected_company: $("select#task_company_id").val() }
                });
            }
            // when load page
            $(function() {
                if ($("select#task_company_id").length) {
                    request_task();
                }
            })
            // when change select
            $(function() {
                $("select#task_company_id").on("change", function() {
                    request_task();
                });
            });
        }
    }

    // select load - dashboard_report Modal
    if ($('#dashboard_report').length) {
        // company select
        if ($('select#dashboard_report_project_id').length) {
            $(function() {
                $("select#dashboard_report_company_id").on("change", function() {
                    $.ajax({
                        url:  "/app/dashboard/filter_dashboard_report_projects_by_company",
                        type: "GET",
                        data: { selected_company: $("select#dashboard_report_company_id").val() }
                    });
                });
            });
        }
    }

    

    // máscaras:
    // example: https://codepen.io/TimArsen/pen/KqdMdR - https://www.youtube.com/watch?v=CT5Iz4gQyb0 - https://nosir.github.io/cleave.js/
    // document.addEventListener('turbolinks:load', () => {
        if ($('.times1').length) {
            new Cleave('.times1', {
                numericOnly: true,
                blocks: [2, 2, 2],
                delimiters: [':'],
            });
        }
    // });
    
    // money mask - https://igorescobar.github.io/jQuery-Mask-Plugin/
    if ($('.real').length) {
        // console.log("Entrou na class real")
        $('.real').mask('#.##0,00', {reverse: true});
    }

    // Hide and Show payment_type on Projects CRUD
    if ($('select#project_payment_type').length) {
        $(function() {
            // $('.by_hour').hide();
            // $('.by_project').hide();
            $(".byHour").removeClass('hidden')
            $(".byProject").addClass('hidden')

            $("select#project_payment_type").on("change", function(){
                if($('select#project_payment_type').val() == 'Por hora') {
                // if($("option[value='Por hora']").is(":checked")) {
                    // setTimeout(function() { 
                        byHour();
                    // }, 1000);
                } else {
                    // setTimeout(function() { 
                        byProject();
                    // }, 2000);
                } 
            });

            function byHour() {
                // $('.byHour').show();
                // $('.byProject').hide();
                $(".byHour").removeClass('hidden')
                $(".byProject").addClass('hidden')
            }

            function byProject() {
                // $('.byHour').show();
                // $('.byProject').hide();
                $(".byHour").addClass('hidden')
                $(".byProject").removeClass('hidden')
            }
            
        });
    }
    
    // dashboard_print_report page
    // if ($("#printableArea").length) {
        // const printDiv = document.querySelector('#print-btn');

    //     window.printDiv(divName) = function printDiv(divName) {
    //         console.log("Entrou na function");
    //         var printContents = document.getElementById(divName).innerHTML;
    //         var originalContents = document.body.innerHTML;
       
    //         document.body.innerHTML = printContents;
       
    //         window.print();
       
    //         document.body.innerHTML = originalContents;
    //    }
    // }
});