require 'rails_helper'

RSpec.describe Api::EventsController, type: :controller do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let!(:event_attendee) { create(:event_attendee, event:, attendee: user) }

  before do
    request.headers.merge!(auth_headers(user))
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: event.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to eq(
        EventSerializer.new(event, { include: %i[organizer final_location attendees] }).serializable_hash.to_json
      )
    end
  end

  describe 'GET #create' do
    it 'returns http unprocessable entity' do
      post :create, params: { event: { title: '', date: '' } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq(
        {
          errors: {
            title: ["can't be blank"],
            date: ["can't be blank"]
          }
        }.to_json
      )
    end
    it 'returns http created' do
      post :create, params: { event: { title: 'title', description: 'description', date: DateTime.tomorrow.to_s } }

      event = Event.order(created_at: :asc).last

      expect(response).to have_http_status(:created)
      expect(response.body).to eq(
        EventSerializer.new(event, { include: %i[organizer final_location attendees] }).serializable_hash.to_json
      )
      expect(event.title).to eq('title')
      expect(event.description).to eq('description')
      expect(event.date).to eq(Time.zone.now.tomorrow.beginning_of_day)
    end
  end
end
