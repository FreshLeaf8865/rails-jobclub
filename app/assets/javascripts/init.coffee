window.App ||= {}

App.init = ->
  $('[data-toggle="tooltip"]').tooltip()
  App.currentUser = $("meta[name=currentUser]").attr("content")

$(document).ready ->
  App.init()
