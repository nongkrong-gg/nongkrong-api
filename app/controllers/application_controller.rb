require 'application_responder'

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  respond_to :json

  self.responder = ApplicationResponder
end
