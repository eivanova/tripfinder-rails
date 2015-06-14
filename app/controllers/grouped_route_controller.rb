class GroupedRouteController < ApplicationController

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

  def find_group(id)
    group = Group.find(id)
    group.user == current_user.email ? group : nil
  end

  def route_from_json json
    route_hash = ActiveSupport::JSON.decode json
    RouteBuilder.build_from_hash route_hash
  end

end
