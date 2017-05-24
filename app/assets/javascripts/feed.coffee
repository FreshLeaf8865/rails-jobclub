$(document).ready ->
  # Configure infinite scroll
  $('.infinite-activities').infinitePages
    loading: ->
      $(this).text('Loading...')
    error: ->
      $(this).button('There was an error, please try again')