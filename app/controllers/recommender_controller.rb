class RecommenderController < ApplicationController

  @@network = Network.new
  @@finder = Finder.new @@network

  # GET /groups/:group/similar
  def similar_to_group
    # Do pseudo-recommendation. Average the parameters of the routes in the given group and run a search for these parameters.
    group_routes = GroupedRoute.where(group_id: params[:group]).collect {| grouped_route | route_from_json grouped_route.route }
    group = Group.find_by(id: params[:group])

    if not group_routes.empty?
      params = average_params(group_routes)
      logger.info(params.inspect)
      @routes = @@finder.find(params).keys
    else
      @routes = []
    end

    @routes = @routes - group_routes
    @title = "Подобни маршрути за група " + group.name

    respond_to do |format|
      format.js { render  "/grouped_route/show_routes" }
    end
  end

  private

  # TODO duplicate code -> move to service layer
  def route_from_json json
    route_hash = ActiveSupport::JSON.decode json
    RouteBuilder.build_from_hash route_hash
  end

  def average_params routes
    params = {}
    params[:days] = (routes.collect { |route| route.days_count }.inject{ |sum, el| sum + el }.to_f / routes.size).ceil.to_i
    params[:hours] = (routes.collect { |route| route.avg_hours }.inject{ |sum, el| sum + el }.to_f / routes.size).ceil.to_i
    params[:cyclic] = routes.collect { |route| route.cyclic? }.count(true) > routes.size.to_f * 2.to_f / 3.to_f
    # params[:difficulty] = (routes.collect { |route| route.difficulty }.inject{ |sum, el| sum + el }.to_f / routes.size).ceil.to_i
    params[:location] = routes.collect { |route| route.points }.flatten.collect { |point| point.region }.uniq
    params
  end

end
