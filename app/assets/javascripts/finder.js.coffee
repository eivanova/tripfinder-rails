# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  # On hover the "Add to group" button, show all groups
  $('.groups-button').hover(
    (ev) -> $.get '/finder/groups_menu', {}, (html, response) ->
      ev.currentTarget.nextElementSibling.innerHTML = html;
      $('.select-group').change(
        (checkEv) -> if checkEv.currentTarget.checked
          add_grouped_route(checkEv.currentTarget.id.split('-')[1])
      );
      currentElement;
    (ev) -> null
   )
  # On hover out of the groups menu, hide the menu
  $('.groups').hover(
    -> null
    -> $(".groups-menu").html("")
   )

# Make request to the server to add this reoute the group
add_grouped_route = (group_id) ->
  route_ser = $('#group-' + group_id).parents('.route').children('.json-route')[0].innerHTML;
  $.post '/groups/' + group_id + '/routes', { route: route_ser }

$(document).ready(ready)
$(document).on('page:load', ready)

