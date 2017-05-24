$(document).ready ->
  $('.at_who_mentions').atwho
    at: '@'
    insertTpl: '@${username}'
    displayTpl: "<li><img src='${avatar_url}' class='mr-2 rounded-circle' width='36'>${name} · ${username}</li>",
    callbacks: remoteFilter: (query, callback) ->
      $.get '/members', { query: query }, ((data) ->
        callback data
        return
      ), 'json'
      return
