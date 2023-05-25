module Api
  class EventsController < ApiController
    load_and_authorize_resource

    def show
      render json: serialized_event
    end

    def create
      @event.save!

      render json: serialized_event, status: :created
    rescue StandardError
      render json: { errors: @event.errors }, status: :unprocessable_entity
    end

    protected

    def event_params
      params.require(:event).permit(:title, :description, :date)
    end

    def serialized_event
      EventSerializer.new(@event, { include: %i[organizer final_location attendees] }).serializable_hash
    end
  end
end
