window.App ||= {}

App.init = ->
  $('[data-toggle="tooltip"]').tooltip()
  App.currentUser = $("meta[name=currentUser]").attr("content")
  if App.currentUser
    OneSignal.push(["sendTags", {user_id: App.currentUser}]);

$(document).ready ->
  App.init()
