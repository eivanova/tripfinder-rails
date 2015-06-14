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
    @routes = GroupedRoute.where(group: params[:group]).collect { |grouped_route| route_from_json(grouped_route.route) }

    respond_to do |format|
      format.js { render :show_routes }
    end
  end

  # POST /groups/:group/routes
  def add_route
    params.permit(:group, :route)
    group = find_group(params[:group])
    return if not group
    groupedRoute = GroupedRoute.new({:group_id => params[:group], :route => params[:route]} )

    if groupedRoute.save
      respond_to do |format|
        format.json { render :json => groupedRoute.to_json }
      end
    end
  end

  # DELETE /groups/:group/routes
  def delete_route
    params.require(:route)
    return if not find_group(params[:group])
    grouped_route = GroupedRoute.where(group_id: params[:group], route: params[:route]).first
    logger.info(grouped_route.inspect)
    grouped_route.destroy

    redirect_to groups_path
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

  def route_from_json json
    route_hash = ActiveSupport::JSON.decode json
    RouteBuilder.build_from_hash route_hash
  end

end
