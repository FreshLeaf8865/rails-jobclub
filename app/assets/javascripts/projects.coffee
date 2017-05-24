$(document).ready ->
  Mousetrap.bind 'left', ->
    document.getElementById("previous_project").click()
    return
  Mousetrap.bind 'right', ->
    document.getElementById("next_project").click()
    return
  $('#project_skills_list').selectize
    plugins: ['remove_button']
    delimiter: ','
    searchField: 'name'
    valueField: 'name'
    labelField: 'name'
    selectOnTab: true
    create: false
    load: (query, callback) ->
      if !query.length
        return callback()
      $.ajax
        url: '/skills.json'
        type: 'GET'
        data:
          query: encodeURIComponent(query)
        error: ->
          callback()
          return
        success: (response) ->
          callback response
          return
      return

  # Configure infinite scroll
  $('.infinite-projects').infinitePages
    loading: ->
      $(this).text('Loading...')
    error: ->
      $(this).button('There was an error, please try again')