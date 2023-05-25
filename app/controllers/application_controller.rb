class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  respond_to :json

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :forbidden }
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :not_found }
    end
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :unprocessable_entity }
    end
  end
end
