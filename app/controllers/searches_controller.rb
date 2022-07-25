class SearchesController < ApplicationController
  skip_authorization_check

  def index
    @results = SearchService.call(query_params)
  end

  private

  def query_params
    params.permit(:query, :scope, :commit)
  end
end
