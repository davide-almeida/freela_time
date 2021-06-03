$(document).on('turbolinks:load', function() {
// $( document ).ready(function() {
    if ($("#dataTable").length) {
        // console.log('Entrou no customDataTables');
        $('#dataTable').DataTable({
          //dom: 'Bfrtip',
          responsive: true,
          buttons: [
              [
                'pageLength'
              ],
              // {
              //     extend: 'print',
              //     text: 'Imprimir',
              //     exportOptions: {
              //         columns: [ 0, 1, 2 ] //Definir quais colunas estarão visíveis para impressão
              //     }
              // },
              {
                extend: 'copy',
                text: 'Copiar'
              },
              {
                  extend: 'csv',
                  text: 'Excel'
              }
            ],
          "pagingType": "simple_numbers",
          "language": {
              "url": "//cdn.datatables.net/plug-ins/1.10.16/i18n/Portuguese-Brasil.json",
            //   buttons: {
            //       pageLength: {
            //           _: "Exibir %d registros"
            //       }
            //   }
          },
          destroy: true
        });
      }
  // Turbolinks.clearCache();
});