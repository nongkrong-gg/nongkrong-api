require 'rails_helper'

RSpec.describe UpController, type: :controller do
  describe 'GET #index' do
    it 'returns http ok' do
      get :index
      expect(response).to have_http_status :ok
    end
  end

  describe 'GET #databases' do
    it 'returns http ok' do
      get :databases
      expect(response).to have_http_status :ok
    end
  end
end
