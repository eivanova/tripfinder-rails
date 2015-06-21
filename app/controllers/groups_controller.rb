class GroupsController < ApplicationController

  before_filter :require_login

  # GET	/groups(.:format)
  def index
    @groups = Group.where user: current_user.email
    @groups = [] if not @groups

    respond_to do |format|
      format.html
      format.json { render :json => @groups.to_json }
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
    @new = true

    respond_to do |format|
      format.js { render :group_details }
    end
  end

  # GET    /groups/:id/edit(.:format)
  def edit
    @group = find_group(params[:id])
    @new = false

    respond_to do |format|
      format.js { render :group_details }
    end
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
    GroupedRoute.destroy_all(group_id: params[:id])
    @group = find_group(params[:id])
    @group.destroy

    redirect_to groups_path, action: 'index', status: 303
  end

  private

  def group_params
    hash_params = params.require(:group).permit(:name, :description, :routes).to_h
    hash_params[:user] = current_user.email
    hash_params
  end

  def find_group(id)
    group = Group.find(id)
    group.user == current_user.email ? group : nil
  end

end
