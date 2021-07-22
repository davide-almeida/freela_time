import 'app/jquery/jquery.min.js';
import 'app/bootstrap/js/bootstrap.bundle.min.js';
import 'app/jquery-easing/jquery.easing.min.js';
import './app/sb-admin-2.js';
import './app/charts.js';
import '@fortawesome/fontawesome-free/js/all';
import './app/timer';
import './app/cleave';
import 'jquery-mask-plugin'

// lembrar de remover esse node module "Validator"
//validator.js - validations field
import validator from 'validator';
// var validator = require('validator');



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

        // if ($('.total_parcel').length) {
        //     new Cleave('.total_parcel', {
        //         numericOnly: true,
        //         blocks: [2],
        //         numeralPositiveOnly: true
        //     });
        // }
    // });
    
    // money mask - https://igorescobar.github.io/jQuery-Mask-Plugin/
    if ($('.real').length) {
        $('.real').mask('#.##0,00', {reverse: true});
    }

    if ($('.total_parcel').length) {
        $('.total_parcel').mask('Z0', {
            translation: {
                'Z': {
                  pattern: /[1-9]/ //, optional: true
                }
              }
        });
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
                //show or hidden inputs by_hour 
                $('input.byHour_input').prop('required',true);
                $('input.byProject_input').prop('required',false);
            }

            function byProject() {
                // $('.byHour').show();
                // $('.byProject').hide();
                $(".byHour").addClass('hidden')
                $(".byProject").removeClass('hidden')
                //show or hidden inputs by_project
                $('input.byHour_input').prop('required',false);
                $('input.byProject_input').prop('required',true);
            }
            
        });
    }

    // hide and show selects on project page
    if ($('select#project_by_project_attributes_payment_type').length) {
        $('input#project_by_project_attributes_total_parcel').prop('disabled', true).val("1");
        $('select#project_by_project_attributes_recurrence').prop('disabled', true).val("Apenas uma vez");

        $("select#project_by_project_attributes_payment_type").on("change", function(){
            if($('select#project_by_project_attributes_payment_type').val() == 'À vista') {
                $('input#project_by_project_attributes_total_parcel').prop('disabled', true).val("1");
                if ($("#project_by_project_attributes_recurrence").prop("Apenas uma vez", 0).val() != "Apenas uma vez") {
                    $('#project_by_project_attributes_recurrence').append('<option id="optionAdded" value="Apenas uma vez">Apenas uma vez</option>');
                    $("#project_by_project_attributes_recurrence").val($("#optionAdded option:first").val());
                }
                $('select#project_by_project_attributes_recurrence').prop('disabled', true).val("Apenas uma vez");

            } else if($('select#project_by_project_attributes_payment_type').val() == 'Parcelado') {
                $('input#project_by_project_attributes_total_parcel').prop('disabled', false).val("");
                $('#project_by_project_attributes_recurrence').prop('disabled', false).val("Apenas uma vez");
                $("#project_by_project_attributes_recurrence option[value='Apenas uma vez']").remove();
            }
        });
    }

    // invoice_date_field and due_date_field validations on project page
    if (($('.invoice_date_field').length) && ($('.due_date_field').length)) {
        function compareDate(date1,date2){
            date1 = date1.split("-").reverse().join("-"); //formating 
            date2 = date2.split("-").reverse().join("-"); //formating 
            var oneDay = 24 * 60 * 60 * 1000;    
            var firstDate = new Date(date1);
            var secondDate = new Date(date2);
            return (Math.round((secondDate.getTime() - firstDate.getTime()) / (oneDay)) >= 0);
        }

        // when submit form, add classes error and show div error
        $("form#new_project").off().on("submit", function(){
            if ($('select#project_payment_type').val() == 'Por hora') {
                const invoice_date = $(".byHour_input.invoice_date_field").val()
                const due_date = $(".byHour_input.due_date_field").val()

                if (compareDate(invoice_date, due_date) == false) {
                    console.log('Por hora - FALSE !!!!!');
                    $(".byHour_input.invoice_date_field").addClass("input-error");
                    $(".byHour_input.due_date_field").addClass("input-error");
                    $( ".byHour.invoice-date-error" ).show();
                    $('<p>A data de fechamento do período deve ser igual ou inferior a data de pagamento.</p>').appendTo('.byHour.invoice-date-error');
                    return false;
                }
                
            } else if ($('select#project_payment_type').val() == 'Por projeto') {
                const invoice_date = $(".byProject_input.invoice_date_field").val()
                const due_date = $(".byProject_input.due_date_field").val()

                if (compareDate(invoice_date, due_date) == false) {
                    console.log('Por projeto - FALSE !!!!!');
                    $(".byProject_input.invoice_date_field").addClass("input-error");
                    $(".byProject_input.due_date_field").addClass("input-error");
                    $( ".byProject.invoice-date-error" ).show();
                    $('<p>A data de fechamento do período deve ser igual ou inferior a data de pagamento.</p>').appendTo('.byProject.invoice-date-error');
                    return false;
                }
            }  
        })

        //remove classes and hide div error
        $("select#project_payment_type").on("change", function() {
            if ($("select#project_payment_type").val() == 'Por hora') {
                $(".byProject_input.invoice_date_field").removeClass("input-error");
                $(".byProject_input.due_date_field").removeClass("input-error");
                $( ".byProject.invoice-date-error" ).hide();
            } else if ($('select#project_payment_type').val() == 'Por projeto') {
                $(".byHour_input.invoice_date_field").removeClass("input-error");
                $(".byHour_input.due_date_field").removeClass("input-error");
                $( ".byProject.invoice-date-error" ).show();
            }
        });
    }

    // invoice_date_field and due_date_field validations on task_schedule page and dashboard page (timer)
    if (($('.task_schedule_form').length) || ($('.dashboard_timer_form').length)) {
        if (($('.start_date_field').length) && ($('.end_date_field').length)) {
            // write on time input
            $(function() {
                $('.start_date_field, .end_date_field').on("change", function() {
                    var start_date = $(".start_date_field").val()
                    var end_date = $(".end_date_field").val()
                    var duration_start_to_end_changed = moment.duration(moment(end_date).diff(moment(start_date))); // get difference
                    var duration_seconds = duration_start_to_end_changed.asSeconds(); // convert to seconds
                    var formatted = moment.duration(duration_seconds, "seconds").format('HH:mm:ss'); // convert seconds to time (HH:mm:ss)
                    $(".time_field").val(formatted)
                    
                    // fix time_field (left zero)
                    var time_field = $(".time_field").val()
                    if (time_field.length == 5) {
                        $(".time_field").val('00:'+time_field)
                    } else if (time_field.length == 2) {
                        $(".time_field").val('00:00:00')
                    }
                });

                //format time field
                // $('.time_field').on("change", function() {
                //     console.log('entrou');
                //     var time_field = $(".time_field").val()
                //     if (time_field.length == 5) {
                //         $(".time_field").val('00:'+time_field)
                //     }
                // });
            });

            // when submit form, add classes error and show div error
            $("form#new_task_schedule").off().on("submit", function(){
                const start_date = $(".start_date_field").val()
                const end_date = $(".end_date_field").val()
                const duration_time = $(".time_field").val()

                if (moment(end_date).isAfter(start_date) == false) {
                    // reset error
                    clearAllErrorsClasses();

                    // show error
                    $(".start_date_field").addClass("input-error");
                    $(".end_date_field").addClass("input-error");
                    $( ".invoice-date-error.msg1-error" ).show();
                    $( ".invoice-date-error.msg2-error" ).show();
                    $('<p>A data de início deve ser inferior a data de conclusão.</p>').appendTo('.invoice-date-error.msg1-error');
                    $('<p>A data de conclusão deve ser superior a data de início.</p>').appendTo('.invoice-date-error.msg2-error');
                    return false;
                } else { // if exist difference between time interval
                    // reset div
                    clearAllErrorsClasses();

                    // show error
                    var duration_start_to_end = moment.duration(moment(end_date).diff(moment(start_date)));
                    duration_start_to_end = duration_start_to_end.asSeconds();
                    var durantion_time_field = moment.duration(duration_time).asSeconds();                  

                    if (duration_start_to_end != durantion_time_field) {
                        $(".start_date_field").addClass("input-error");
                        $(".end_date_field").addClass("input-error");
                        $(".time_field").addClass("input-error");
                        $( ".invoice-date-error.msg3-error" ).show();
                        $('<p>O intervalo de tempo entre a data de início e a data de conclusão devem corresponder ao campo <strong>tempo decorrido</strong>.</p>').appendTo('.invoice-date-error.msg3-error');
                        return false;
                    }
                    // convert seconds to time
                    // d = moment.duration({s: 1000});
                    // moment().startOf('day').add(d).format('HH:mm:ss')
                }

            })
        }
    }

    // clear error-classes
    function clearAllErrorsClasses() {
        // reset div and classes errors
        $('.invoice-date-error.msg1-error').text('');
        $('.invoice-date-error.msg2-error').text('');
        $('.invoice-date-error.msg3-error').text('');
        $( ".invoice-date-error.msg1-error" ).hide();
        $( ".invoice-date-error.msg2-error" ).hide();
        $( ".invoice-date-error.msg3-error" ).hide();
        $( ".start_date_field" ).removeClass("input-error");
        $( ".end_date_field" ).removeClass("input-error");
        $( ".time_field" ).removeClass("input-error");
    }

});