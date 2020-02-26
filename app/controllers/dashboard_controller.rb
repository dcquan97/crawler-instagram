class DashboardController < ApplicationController
  def index
    @image = Image.first
  end
end
