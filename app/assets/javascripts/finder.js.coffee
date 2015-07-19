# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

app.ready = () ->
  # On hover the "Add to group" button, show all groups
  $('.groups-button').click( (ev) ->
    app.get_groups_menu(ev)
   )

# Request list of available groups menu
app.get_groups_menu = (ev) ->
  route_ser = $(ev.currentTarget).parents('.groups-menu').children('.json-route')[0].innerHTML;
  $.post '/finder/groups_menu', {route: route_ser }, (html, response) ->
    ev.currentTarget.nextElementSibling.innerHTML = html;
    # Add select handler, which will handle add/remove of the route from specific group
    $('.group-menu-item a').click( (checkEv) ->
      group_id = $(checkEv.currentTarget).attr("data-value");
      to_remove = $("#check-" + group_id).prop("checked")
      if checkEv.target.id == "check-" + group_id
        to_remove = !to_remove
        checkEv.stopPropagation()

      if to_remove
        app.remove_grouped_route(group_id, route_ser)
      else
        app.add_grouped_route(group_id, route_ser)
     );

# Make request to the server to add this route the group
app.add_grouped_route = (group_id, route_ser) ->
  $.post '/groups/' + group_id + '/routes', { route: route_ser }
  $("#check-" + group_id).prop("checked", true);

app.remove_grouped_route = (group_id, route_ser) ->
  $.ajax
    url: ('/groups/' + group_id + '/routes'),
    data: { route: route_ser },
    type: 'DELETE'
  $("#check-" + group_id).prop("checked", false);

$(document).ready(app.ready)
$(document).on('page:load', app.ready)


