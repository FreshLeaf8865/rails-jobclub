App.conversations = App.cable.subscriptions.create "ConversationsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    text = data.message.text
    if text.length > 25
      text = text.substring(0,22) + "..."
    active_conversation = $("[data-behavior='messages'][data-conversation-id='#{data.conversation_id}']")
    current_user_id = App.currentUser #is used to retrieve count of unread message from hash

    # if we are viewing this conversation id
    if active_conversation.length > 0
      partial = data.message_partial

      # If the message is coming current user append my_message class
      if data.user_id.toString() == current_user_id.toString()
        partial = data.message_partial.replace("<div class='message'>", "<div class='message my_message'>");
        text = "You: " + text

      if document.hidden
        unread_cell = $(".unread_cell")
        if unread_cell.length == 0
          active_conversation.append("<div class='unread_cell'>Unread</div>")
      else
        App.last_read.update(data.conversation_id)


      # Insert the message
      App.typing.showTypingIndicator(false)
      active_conversation.append(partial)
      App.conversations.scrollToBottom()

    conversation_list_item = $("#conversation_#{data.conversation_id}")
    if conversation_list_item.length > 0
        preview = conversation_list_item.find(".conversation_preview")
        preview.text(text)
        conversation_list_item.addClass("unread")
        if active_conversation.length == 0 || document.hidden #if conversation is not open or document is hidden we need to update the count in the list
          App.conversations.update_conversation_list_count(conversation_list_item,data.unread_message_hash[current_user_id])
    #update total count on title bar
    @perform "update_title_count"

 #Function for updating count of unread messages in conversation list
  update_conversation_list_count: (conversation_list_item,unread_count) ->
    countElement = conversation_list_item.find('.badge')
    if countElement.length > 0 && unread_count > 0 #if there is unread message already in the conversation
      countElement.html(unread_count)
    else if unread_count > 0 #first unread message
      conversation_list_item.find('.conversation_time').append("<span class='badge badge-primary text-right'></span>")
      conversation_list_item.find('.badge').html(unread_count)

  send_message: (conversation_id, text) ->
    # Calls ConversationsChannel.send_messsage
    App.typing.showTypingIndicator(false)
    @perform "send_message", {conversation_id: conversation_id, text: text}

  scrollToBottom: ->
    chat = $('#messages')
    scrollHeight = chat.prop("scrollHeight")
    chat.scrollTop(scrollHeight)

  handleVisiblityChange: ->
    conversation_id = $("[data-behavior='messages']").data("conversation-id")
    $unread_cell = $(".unread_cell")
    countElement = $("#conversation_#{conversation_id}").find('.badge')
    if $unread_cell.length > 0
      App.last_read.update(conversation_id)
      $unread_cell.remove()
      $("#conversation_#{conversation_id}").removeClass("unread")
    if countElement.length > 0
      countElement.remove()

$(document).ready ->
  $(document).on "click", App.conversations.handleVisiblityChange
  $('.conversation_cell').click (e) ->
    e.stopPropagation()
    return
  # Scroll to bottom when starting conversation
  App.conversations.scrollToBottom()

  # submit message on enter
  $("#new_message").on "keypress", (e) ->
    if e && e.keyCode == 13
      e.preventDefault()
      $(this).submit()

  # Use Channel to send message
  $("#new_message").on "submit", (e) ->
    e.preventDefault()

    conversation_id = $("#message_conversation_id").val()
    text_field = $("#message_text")

    App.conversations.send_message(conversation_id, text_field.val())

    text_field.val("")

  return
