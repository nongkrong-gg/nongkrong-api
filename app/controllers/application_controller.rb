class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  respond_to :json

  rescue_from CanCan::AccessDenied do
    respond_to do |format|
      format.json { head :forbidden }
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |format|
      format.json { head :not_found }
    end
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :unprocessable_entity }
    end
  end

  rescue_from ArgumentError do |exception|
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :bad_request }
    end
  end
end
