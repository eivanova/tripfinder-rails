class UserSessionsController < ApplicationController
  
  # GET user_sessions/new	
  def new
    @user = User.new	  
  end

  # POST user_sessions 
  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to(:root, notice: 'Login successful')
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  # DELETE user_sessions/
  def destroy
    logout
    redirect_to(:root, notice: 'Logged out!')	
  end
end
