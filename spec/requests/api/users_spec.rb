require "swagger_helper"
RSpec.describe "users_controller", type: :request do
  path "/register" do
    post "Create a new Owner and company" do
      tags "Users"
      consumes "application/json"
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          company_name: { type: :string },
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: ["email", "password", "password_confirmation"]
          },
        },
        required: ["company_name", "user"],
      }

      response "201", "owner created" do
        let(:user) { { company_name: "Company", user: { email: "user@example.com", password: "password", password_confirmation: "password" } } }
        run_test!
      end

      response "422", "invalid request" do
        let(:user) { { company_name: "Company", user: { email: "user@example.com" } } }
        run_test!
      end
    end
  end
end