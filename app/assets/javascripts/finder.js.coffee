# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = () ->
  # On hover the "Add to group" button, show all groups
  $('.groups-button').hover(
    (ev) -> get_groups_menu(ev)
    (ev) -> null
   )
  # On hover out of the groups menu, hide the menu
  $('.groups').hover(
    -> null
    -> $(".groups-menu").html("")
   )

# Request list of available groups menu
get_groups_menu = (ev) ->
  route_ser = $(ev.currentTarget).parents('.groups').children('.json-route')[0].innerHTML;
  $.post '/finder/groups_menu', {route: route_ser }, (html, response) ->
    ev.currentTarget.nextElementSibling.innerHTML = html;
    # Add select handler, which will handle add/remove of the route from specific group
    $('.select-group').change(
      (checkEv) ->
        group_id = checkEv.currentTarget.id.split('-')[1]
        route_ser = $('#group-' + group_id).parents('.groups').children('.json-route')[0].innerHTML;
        if checkEv.currentTarget.checked
          add_grouped_route(group_id, route_ser)
        else
          remove_grouped_route(group_id, route_ser)
     );

# Make request to the server to add this route the group
add_grouped_route = (group_id, route_ser) ->
  $.post '/groups/' + group_id + '/routes', { route: route_ser }

remove_grouped_route = (group_id, route_ser) ->
  $.ajax
    url: '/groups/' + group_id + '/routes',
    data: { route: route_ser }
    type: 'DELETE'

$(document).ready(ready)
$(document).on('page:load', ready)

