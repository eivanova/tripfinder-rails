class ChatterBotController < ApplicationController

  @@eliza = Eliza.new

  # Initial page
  # GET  /chatter_bot/chat(.:format)
  def chat
    session[:chatterbot] = {}
  end

  # GET  /chatter_bot/reply(.:format)
  def reply
    input = params[:input]
    @reply = @@eliza.repl(input, session[:chatterbot])

    respond_to do |format|
       format.js { render :reply }
    end
  end
end
