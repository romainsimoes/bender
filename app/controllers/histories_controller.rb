class HistoriesController < ApplicationController

  def index
    @histories = History.all
  end

end
