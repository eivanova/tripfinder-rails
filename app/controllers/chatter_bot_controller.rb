class ChatterBotController < ApplicationController

  @@eliza = Eliza.new

  # Initial page
  # GET  /chatter_bot/chat(.:format)
  def chat
    session[:chatterbot] = {}
    @reply = @@eliza.repl("", session[:chatterbox])
  end

  # POST  /chatter_bot/reply(.:format)
  def reply
    input = params[:input]
    @reply = @@eliza.repl(input, session[:chatterbot])

    respond_to do |format|
      format.json { render :text => @reply }
    end
  end
end
