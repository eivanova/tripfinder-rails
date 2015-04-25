require_relative '../helpers/domain.rb'

class FinderController < ApplicationController

  def find
    network = Network.new("datasets/points.txt", "datasets/routes.txt")	
    finder = Finder.new network	
    @routes = finder.find(params).keys	  
  end
end
