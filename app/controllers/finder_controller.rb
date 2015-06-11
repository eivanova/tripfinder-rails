require 'tripfinder'

class FinderController < ApplicationController

  skip_before_action :require_login, except: [:groups_menu]

  def find
    redirect_to '/'  if request.get?
    parameter_map = params.to_h.map{ |k, v| [k.to_sym, v] }.to_h
    # TODO read about singleton classes in Rails
    network = Network.new
    finder = Finder.new network
    @routes = finder.find(parameter_map).keys
  end

  def groups_menu
    @groups  = Group.where user: current_user.email
    @groups = [] if not @groups

    respond_to do |format|
      format.html { render :partial => 'groups_menu' }
    end
  end
end
