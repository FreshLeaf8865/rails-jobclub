$(document).ready ->
  el = document.getElementById('sortable_user_skills')
  if el
    sortable = Sortable.create(el, {
      handle: ".drag_handle",
      onEnd: (event) ->
        user_skill_id = $(event.item).attr("data-id");
        $.ajax
          type: 'PUT'
          url: '/user_skills/' + user_skill_id
          data: user_skill: position: event.newIndex
        return
    })
