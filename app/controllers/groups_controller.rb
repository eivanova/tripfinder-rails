class GroupsController < ApplicationController

  before_filter :require_login

  # GET	/groups(.:format) 
  def index
    @groups = Group.where user: current_user.email
    @groups = [] if not @groups   

    respond_to do |format|
      format.html 
      format.json { render :partial => 'groups' }
    end 
  end
  
  # GET    /groups/:id(.:format) 
  def show
    @group = find_group(params[:id])  
 
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
    @group = find_group(params[:id])	  
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
    @group = find_group(params[:id])
     
    if @group.update(group_params)
      redirect_to @group
    else
      render 'edit'
    end
  end
  
  # DELETE /groups/:id(.:format) 
  def destroy
    @group = find_group(params[:id]) 
    @group.destroy

    redirect_to groups_path
  end

  # GET /groups/:group/routes
  def show_routes
    params.require(:group)
    @routes = GroupedRoute.find_by group: params[:group]    
    
    respond_to do |format|
      format.js { render :show_routes }
    end
  end

  # POST /groups/:group/routes
  def add_route
    params.require(:group, :route).permit(:group, :route)
    return if not find_group(params[:group])
    groupedRoute = GroupedRoute.new(params)

    if groupedRoute.save
      respond_to do |format|
        format.js { render 'groups' }
      end
    end
  end

  # DELETE /groups/:group/routes/:id
  def delete_route
    params.require(:group, :id)
    return if not find_group(params[:group])
    groupedRoute = GroupedRoute.find(params[:id])
    groupedRoute.destroy

    redirect_to groups_path
  end

  private
  
  def group_params
    hash_params = params.require(:group).permit(:name, :description, :routes).to_h
    hash_params[:user] = current_user.email
    hash_params
  end

  def find_group(id)
    group = Group.find(params[:id])
    group.user == current_user.email ? group : nil
  end
end
