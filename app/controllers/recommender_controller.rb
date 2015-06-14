class RecommenderController < ApplicationController

  # GET /groups/:group/similar
  def similar_to_group
    # Do pseudo-recommendation. Average the parameters of the routes in the given group and run a search for these parameters.
    group_routes = GroupedRoute.where(group_id: params[:group]).collect {| grouped_route | route_from_json grouped_route.route }

    if not group_routes.empty?
      params = average_params(group_routes)
      # TODO learn about rails application service layer. Get rid of this duplicate code -> see FinderController#find
      network = Network.new
      finder = Finder.new network
      @routes = finder.find(params).keys
    else
      @routes = []
    end

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
    params[:days] = routes.collect { |route| route.days_count }.inject{ |sum, el| sum + el }.to_f / routes.size
    params[:hours] = routes.collect { |route| route.avg_hours }.inject{ |sum, el| sum + el }.to_f / routes.size
    params[:cyclic] = routes.collect { |route| route.cyclic? }.count(true) > routes.size
    params[:location] = routes.collect { |route| route.points }.flatten.collect { |point| point.region }.uniq
    params
  end

end
