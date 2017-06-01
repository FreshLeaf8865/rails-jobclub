App.title_update = App.cable.subscriptions.create 'TitleUpdateChannel',
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    count = data.total_count
    titleText = $('title').text();
    if count > 0 #when count is increased it should be updated on title bar
      if titleText.includes(')')
        titleText = "(#{count})" + titleText.split(')')[1]
      else
        titleText = "(#{count})" + titleText
      $('title').html titleText
    else #this condition is for removing the count from title when there is no read message
      if titleText.includes(')')
        titleText = titleText.split(')')[1]
        $('title').html titleText
