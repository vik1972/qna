require 'rails_helper'

RSpec.describe SearchService do
  SearchService::SCOPES.each do |scope|
    it "call search from #{scope}" do
      expect(scope.classify.constantize).to receive(:search).with(scope)
      SearchService.call(query: scope, scope: scope)
    end
  end

  it 'not exist scope' do
    expect(SearchService.call(query: 'test', scope: 'SCOPES')).to be_nil
  end
end