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
                items: {
                  days: { type: :string }
                }
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

  path "/events/{id}/assign_employees" do
    post "Assign employees to events" do
      tags "Events"
      consumes "application/json"
      parameter name: :id, in: :path, type: :string, description: 'event_id where employee will be assigned'
      parameter name: "employee_ids[]", in: :body, schema: {
        type: :object,
        properties: {
          employee_emails: {
            type: :array,
            items: {
            days: { type: :string }
            }
          }
        }
      }

      response "201", "employees assigned" do
        let(:event) { { employee_emails: ["test1@gmail.com", "test2@gmail.com"] } }
        run_test!
      end

      response "422", "invalid request" do
        let(:event) { { employee_emails: [] }  }
        run_test!
      end
    end
  end

  path "/events/{id}/update_recurrences" do
    post "update recurring event" do
      tags "Events"
      consumes "application/json"
      parameter name: :id, in: :path, type: :string, description: 'event_id which will be updated'
      parameter name: :event, in: :body, schema: {
        type: :object,
        properties: {
          update_type: {type: :string },
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
                items: {
                  days: { type: :string }
                }
              }
            },
          },
        },
        required: ["event"],
      }

      response "201", "event updated" do
        let(:event) { { update_type: "all",  "event": {
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

  path "/events" do
    get "update recurring event" do
      tags "Events"
      consumes "application/json"
      parameter name: :start_date, in: :query, type: :string, description: 'start date of range'
      parameter name: :end_date, in: :query, type: :string, description: 'end date of range'

      response "200", "event updated" do
        let(:event) { { update_type: "all",  "event": {
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
