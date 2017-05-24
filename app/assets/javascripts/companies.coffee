$(document).ready ->      
  $('#company_tags_list').selectize
    plugins: ['remove_button']
    delimiter: ','
    selectOnTab: true
    create: true
