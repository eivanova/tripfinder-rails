# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = -> 
  $('.routes-button').hover( 
    -> $.get '/finder/groups_menu', {}, (html, response) -> 
      $(".routes-menu").html(html)
      $('.select-group').select(
        -> add_grouped_route($(this).attr("id").split('-')[1])
       )
    -> null
   )  
  $('.routes-menu').hover(
    -> null
    -> $(".routes-menu").html("")  
   )

groups_button = ->
  $('.select-group').select(
    -> add_grouped_route($(this).attr("id").split('-')[1])
   )

$(document).ready(ready)
$(document).on('page:load', ready)

add_grouped_route = (group_id) ->
  route_ser = $('.group-' + group_id).parents('.route').children('json-route').html
  $.post '/groups/' + group_id + '/routes', { route: route_ser }
