$(document).on('turbolinks:load', function() {
// document.addEventListener("turbolinks:load", function() {
    // console.log('Entrou no timer.js');

    if ($("#time").length) {
        // console.log('Entrou no TIMER');
        const timer = document.querySelector('#time');
        const start_btn = document.querySelector('#start_btn');
        const pause_btn = document.querySelector('#pause_btn');
        const reset_btn = document.querySelector('#reset_btn');
        const end_btn = document.querySelector('#end_btn');
        // const send_btn = document.querySelector('#send_btn');

        let time = 0,
        interval;

        var start_time;
        var end_time;
        var start_today_global

        // hide timer buttons
        window.start_timer = function start_timer() {
            hideBtn([pause_btn, reset_btn, end_btn]);
        }
        

        window.showTime = function showTime() {
            time += 1;
            timer.innerHTML = toHHMMSS(time);
        }

        window.start =  function start() {
            interval = setInterval(showTime, 1000);
            hideBtn([start_btn]);
            showBtn([pause_btn, reset_btn, end_btn]);
            // console.log('entrou no start');
            var start_today = new Date();
            start_time = start_today.getFullYear()+"-"+(start_today.getMonth()+1).toString().padStart(2, '0').toString()+"-"+start_today.getDate().toString().padStart(2, '0')+"T"+start_today.getHours().toString().padStart(2, "0")+":"+start_today.getMinutes().toString().padStart(2, "0");
            start_today_global = start_today
            // format '2018-06-12T19:30'
            // console.log(start_time);
        }

        window.pause = function pause() {
            if (interval) {
                clearInterval(interval);
                interval = null;
                pause_btn.innerHTML = 'Continuar';
            } else {
                interval = setInterval(showTime, 1000);
                pause_btn.innerHTML = 'Pausar';
            }
        }

        window.reset = function reset() {
            clearInterval(interval);
            interval = null;
            pause_btn.innerHTML = 'Pausar';
            time = 0;
            timer.innerHTML = toHHMMSS(time);
            hideBtn([pause_btn, reset_btn, end_btn]);
            showBtn([start_btn]);
        }

        window.toHHMMSS = function toHHMMSS(time) {
            let hours = Math.floor(time / 3600);
            let minutes = Math.floor((time - hours * 3600) / 60);
            let seconds = time - hours * 3600 - minutes * 60;

            hours = `${hours}`.padStart(2, '0');
            minutes = `${minutes}`.padStart(2, '0');
            seconds = `${seconds}`.padStart(2, '0');

            return hours + ':' + minutes + ':' + seconds;
        }

        window.end = function end() {
            if (interval) {
                clearInterval(interval);
                interval = null;
                pause_btn.innerHTML = 'Continuar';
            }

            // add datetime value in inputs
            // example format '2018-06-12T19:30'
            $("#task_schedule_start_date").val(start_time);
            var end_today = new Date();
            end_time = end_today.getFullYear()+"-"+(end_today.getMonth()+1).toString().padStart(2, '0').toString()+"-"+end_today.getDate().toString().padStart(2, '0')+"T"+end_today.getHours().toString().padStart(2, "0")+":"+end_today.getMinutes().toString().padStart(2, "0");
            $("#task_schedule_end_date").val(end_time);
            // console.log('entrou no end');
            // console.log(end_time);

            // status
            // var start_clock = start_time.getFullYear()+"-"+(start_time.getMonth()+1).toString().padStart(2, '0').toString()+"-"+start_time.getDate().toString().padStart(2, '0')+"T"+start_time.getHours()+":"+start_time.getMinutes();
            var start_clock = start_today_global.getDate().toString().padStart(2, '0')+"/"+(start_today_global.getMonth()+1).toString().padStart(2, '0').toString()+"/"+start_today_global.getFullYear()+" "+start_today_global.getHours().toString().padStart(2, "0")+":"+start_today_global.getMinutes().toString().padStart(2, "0");
            var end_clock = end_today.getDate().toString().padStart(2, '0')+"/"+(end_today.getMonth()+1).toString().padStart(2, '0').toString()+"/"+end_today.getFullYear()+" "+end_today.getHours().toString().padStart(2, "0")+":"+end_today.getMinutes().toString().padStart(2, "0");
            var clock = document.getElementById("time").innerHTML
            $(".modal-body #start_clock").html(start_clock);
            $(".modal-body #end_clock").html(end_clock);
            $(".modal-body .work_hour").html(clock);
            $("#task_schedule_work_hour").val(clock);

            // console.log(start_time);
            // console.log(end_time);
            // console.log(clock);
        }

        window.send = function send() {
            reset();
            // console.log('entrou no send_btn');
        }

        window.showBtn = function showBtn(btnArr) {
            btnArr.forEach((btn) => (btn.style.display = 'inline-block'));
        }
        window.hideBtn = function hideBtn(btnArr) {
            btnArr.forEach((btn) => (btn.style.display = 'none'));
        }
    }

});