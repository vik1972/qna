# frozen_string_literal: true

require 'rails_helper'

describe "Profiles API", type: :request do
  let(:headers) { { "CONTENT_TYPE" => 'application/json',
                    "ACCEPT" => 'application/json' } }

  describe "GET /api/v1/profiles/me" do
    let(:api_path) {  "/api/v1/profiles/me" }

    it_behaves_like "API Authorizable" do
      let(:method) { :get }
    end

    context "authorized" do
      let(:me) { create(:user) }
      let(:user) { json[me]}
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like "Request successful"

      it_behaves_like "Public fields" do
        let(:attrs) { %w[id email admin created_at updated_at] }
        let(:resource_response) { json['user'] }
        let(:resource) { me }
      end

      it "does not returns private fields" do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe "GET /api/v1/profiles" do
    let(:api_path) {  "/api/v1/profiles" }

    it_behaves_like "API Authorizable" do
      let(:method) { :get }
    end

    context "authorized" do
      let(:users) { create_list(:user, 3) }
      let(:me) { users.first}
      let(:user) { users.last }
      let(:user_response) { json['users'].last }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like "Request successful"

      it "returns list of users without one" do
        expect(json['users'].size).to eq (users.size - 1)
      end

      it "does not return me" do
        expect(json['users'].map(&:user['id'])).to_not eq me.id
      end

      it_behaves_like "Public fields" do
        let(:attrs) { %w[id email admin created_at updated_at] }
        let(:resource_response) { json['users'].last }
        let(:resource) { users.last }
      end

      it "does not return private fields" do
        attrs = %w[password encrypted_password]
        attrs.each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end
    end
  end
end