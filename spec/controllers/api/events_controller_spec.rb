require 'rails_helper'

INCLUDE_PARAM = %i[organizer midpoint_location final_location attendees].freeze

RSpec.describe Api::EventsController, type: :controller do
  let(:organizer) { create(:user) }
  let(:event) { create(:event, organizer:) }
  let(:attendee) { create(:user) }
  let!(:event_attendee) { create(:event_attendee, event:, attendee:) }

  context 'when user is not logged in' do
    describe 'GET #show' do
      it 'returns http unauthorized' do
        get :show, params: { id: event.id }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end

    describe 'GET #create' do
      it 'returns http unauthorized' do
        post :create, params: { event: { title: 'title', description: 'description', date: DateTime.tomorrow.to_s } }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end

    describe 'PATCH #update' do
      it 'returns http unauthorized' do
        patch :update,
              params: { id: event.id,
                        event: { title: 'title', description: 'description', date: DateTime.tomorrow.to_s } }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end

    describe 'DELETE #destroy' do
      it 'returns http unauthorized' do
        delete :destroy, params: { id: event.id }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end

    describe 'POST #check_in' do
      it 'returns http unauthorized' do
        post :check_in, params: { id: event.id, location: { latitude: 1, longitude: 1 } }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end

  context 'when user is the organizer' do
    before do
      request.headers.merge!(auth_headers(organizer))
    end

    describe 'GET #show' do
      it 'returns http success' do
        get :show, params: { id: event.id }

        expect(response).to have_http_status(:success)
        expect(response.body).to eq(
          EventSerializer.new(event, { include: INCLUDE_PARAM }).serializable_hash.to_json
        )
      end
    end

    describe 'GET #create' do
      it 'returns http created' do
        post :create, params: { event: { title: 'title', description: 'description', date: DateTime.tomorrow.to_s } }

        event = Event.order(created_at: :asc).last

        expect(response).to have_http_status(:created)
        expect(response.body).to eq(
          EventSerializer.new(event, { include: INCLUDE_PARAM }).serializable_hash.to_json
        )
        expect(event.title).to eq('title')
        expect(event.description).to eq('description')
        expect(event.date).to eq(Time.zone.now.tomorrow.beginning_of_day)
      end
    end

    describe 'PATCH #update' do
      it 'returns http ok' do
        patch :update,
              params: { id: event.id,
                        event: { title: 'title', description: 'description', date: DateTime.tomorrow.to_s } }

        event.reload

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(
          EventSerializer.new(event, { include: INCLUDE_PARAM }).serializable_hash.to_json
        )
        expect(event.title).to eq('title')
        expect(event.description).to eq('description')
        expect(event.date).to eq(Time.zone.now.tomorrow.beginning_of_day)
      end
    end

    describe 'DELETE #destroy' do
      it 'returns http no content' do
        expect do
          delete :destroy, params: { id: event.id }
        end.to change(Event, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    describe 'POST #check_in' do
      it 'returns http created' do
        expect do
          post :check_in, params: { id: event.id, location: { latitude: 1, longitude: 1 } }
        end.to change(EventAttendee, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.body).to eq(
          EventSerializer.new(event.reload, { include: INCLUDE_PARAM }).serializable_hash.to_json
        )
      end
    end
  end

  context 'when user is the attendee' do
    before do
      request.headers.merge!(auth_headers(attendee))
    end

    describe 'GET #show' do
      it 'returns http success' do
        get :show, params: { id: event.id }

        expect(response).to have_http_status(:success)
        expect(response.body).to eq(
          EventSerializer.new(event, { include: INCLUDE_PARAM }).serializable_hash.to_json
        )
      end
    end

    describe 'GET #create' do
      it 'returns http created' do
        post :create, params: { event: { title: 'title', description: 'description', date: DateTime.tomorrow.to_s } }

        event = Event.order(created_at: :asc).last

        expect(response).to have_http_status(:created)
        expect(response.body).to eq(
          EventSerializer.new(event, { include: INCLUDE_PARAM }).serializable_hash.to_json
        )
        expect(event.title).to eq('title')
        expect(event.description).to eq('description')
        expect(event.date).to eq(Time.zone.now.tomorrow.beginning_of_day)
      end
    end

    describe 'PATCH #update' do
      it 'returns http forbidden' do
        patch :update,
              params: { id: event.id,
                        event: { title: 'title', description: 'description', date: DateTime.tomorrow.to_s } }

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'DELETE #destroy' do
      it 'returns http forbidden' do
        expect do
          delete :destroy, params: { id: event.id }
        end.to change(Event, :count).by(0)

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'POST #check_in' do
      it 'returns http forbidden' do
        post :check_in, params: { id: event.id, location: { latitude: 1, longitude: 1 } }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
