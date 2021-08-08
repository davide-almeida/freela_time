//= require jquery3
//= require jquery_ujs
//= require nested_form_fields
//= require chosen-jquery

// console.log('entrou no sprockets!')

// collection select das tags
$(document).on('turbolinks:load', function() {
    if ($('.tags').length) {
        // console.log('Entrou no IF tags');
        $('.tags').chosen({
            allow_single_deselect: true,
            no_results_text: 'Nome não encontrado:',
            width: '100%',
            placeholder_text_multiple: 'Digite o nome de cada contato'
        })
        
    };
});