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
end
