class GroupsController < ApplicationController

  before_filter :require_login

  # GET	/groups(.:format) 
  def index
    @groups = Group.where user: current_user.email
    @groups = [] if not @groups    
  end
  
  # GET    /groups/:id(.:format) 
  def show
    @group = Group.find(params[:id])	  
 
    respond_to do |format|
      format.js { render :show_group }
    end
  end

  # GET    /groups/new(.:format)
  def new
    @group = Group.new	 
    
    respond_to do |format|
      format.js { render :new_group }
    end
  end
  
  # GET    /groups/:id/edit(.:format) 
  def edit
    @group = Group.find(params[:id])	  
  end  

  # POST   /groups(.:format) 
  def create
    @group = Group.new(group_params)
 
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end    
  end
  
  # PUT    /groups/:id(.:format) 
  # PATCH  /groups/:id(.:format)    
  def update
    @group = Group.find(params[:id])
     
    if @group.update(group_params)
      redirect_to @group
    else
      render 'edit'
    end
  end
  
  # DELETE /groups/:id(.:format) 
  def destroy
    @group = Group.find(params[:id]) 
    @group.destroy

    redirect_to groups_path
  end

  private
  
  def group_params
    hash_params = params.require(:group).permit(:name, :description, :routes).to_h
    hash_params[:user] = current_user.email
    hash_params
  end
end
