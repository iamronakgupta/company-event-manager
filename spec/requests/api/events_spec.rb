require 'swagger_helper'

RSpec.describe 'events_controller', type: :request do
  path "/events" do
    post "Create a new Event" do
      tags "Events"
      consumes "application/json"
      parameter name: :event, in: :body, schema: {
        type: :object,
        properties: {
          event: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              start_date: { type: :datetime },
              start_time: { type: :datetime },
              end_time: { type: :datetime },
              recurrence: { type: :boolean },
              recurrence_week: { type: :integer },
              ends_on: { type: :time },
              repeat_days: {
                type: :array,
                days: {type: :string}
              }
            },
            required: ["name", "description", "start_time", "end_time", "start_date", "recurrence" ]
          },
        },
        required: ["event"],
      }

      response "201", "event created" do
        let(:event) { {  "event": {
          "name": "Test Event",
          "description": "Some des",
          "start_time": "14:00",
          "end_time": "16:00",
          "start_date": "03/04/2017",
          "recurrence": "true"
          }} }
        run_test!
      end

      response "422", "invalid request" do
        let(:event) { {  "event": {
          "name": "Test Event",
          "description": "Some des",
          "start_time": "14:00"
          }} }
        run_test!
      end
    end
  end
end
