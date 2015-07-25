# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = () -> $('#chat-input').keypress( (ev) ->
  if(ev.keyCode == 13)
    val = $('#chat-input').val()
    post_input(val);
    get_reply(val);
)

post_input = (val) ->
  $('#chat-input').val("")
  new_div = document.createElement( 'div' )
  new_div.className = "user-message pull-right"
  new_div.innerText = val
  $('#messages').append(new_div)

get_reply = (val) ->
  $.ajax 'reply.json',
      type: 'POST'
      dataType: "html",
      data: { input: val }
      success: (data, textStatus, jqXHR) ->
        post_reply(data)

post_reply = (data) ->
  new_div = document.createElement( 'div' )
  new_div.className = "gin-message pull-left"
  new_div.innerText = data
  $('#messages').append(new_div)


$(document).ready(ready)
$(document).on('page:load', ready)
