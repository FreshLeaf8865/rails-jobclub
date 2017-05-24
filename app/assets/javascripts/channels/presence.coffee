App.presence = App.cable.subscriptions.create('PresenceChannel',
  connected: ->
    @perform 'user_present'
    return

  disconnected: ->
    @perform 'user_inactive'
    return

  rejected: ->
    @perform 'user_inactive'
    return

  received: (data) ->
    user_presence = $("[data-behavior='presence'][data-user-id='#{data.user_id}']")
    if user_presence.length > 0 
      if data.event == "active"
        user_presence.addClass("presence_active")
      else
        user_presence.removeClass("presence_active")
    return

  setCurrentUserActive: ->
    @perform 'user_present'
)
