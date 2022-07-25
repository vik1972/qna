class SearchesController < ApplicationController
  skip_authorization_check

  def index
    if !params[:query].empty?
      @results = SearchService.call(query_params)
    end
  end

  private

  def query_params
    params.permit(:query, :scope, :commit)
  end
end
