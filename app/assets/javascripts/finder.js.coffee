# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = -> 
  $('.routes-button').hover( 
    -> $.get '/groups.json', {}, (data, response) -> 
      alert(data) 
   )   

$(document).ready(ready)
$(document).on('page:load', ready)
