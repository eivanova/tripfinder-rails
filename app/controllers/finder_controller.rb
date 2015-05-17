require 'tripfinder'

class FinderController < ApplicationController

  def find
    redirect_to '/'  if request.get? 	  
    parameter_map = params.to_h.map{ |k, v| [k.to_sym, v] }.to_h	 
    # TODO read about singleton classes in Rails 
    network = Network.new	
    finder = Finder.new network
    @routes = finder.find(parameter_map).keys 
  end
end
