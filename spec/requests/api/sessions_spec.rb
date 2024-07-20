require 'swagger_helper'

RSpec.describe 'sessions_controller', type: :request do
  path "/login" do
    post "create session" do
      tags "Session"
      consumes "application/json"
      parameter name: :login, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: ["email", "password"],
      }

      response "201", "Session created" do
        # let(:user) { email: "user@example.com", password: "password" }
        run_test!
      end

      response "401", "Unauthorised" do
        # let(:user) { email: "user@example.com", password: "password" }
        run_test!
      end
    end
  end
end
