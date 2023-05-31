module Api
  class EventsController < ApiController
    load_and_authorize_resource

    def show
      render json: serialized_event if stale?(@event)
    end

    def create
      @event.save!

      render json: serialized_event, status: :created
    end

    def update
      @event.update!(event_params)

      render json: serialized_event, status: :ok
    end

    def destroy
      @event.destroy
    end

    def check_in
      authorize! :check_in, @event

      @event.check_in!(attendee: current_user, **location_params.to_h.symbolize_keys)

      render json: serialized_event, status: :created
    end

    def final_location
      authorize! :final_location, @event

      @event.update!(final_location: place_params[:id])

      render json: serialized_event, status: :ok
    end

    protected

    def event_params
      params.require(:event).permit(:title, :description, :date)
    end

    def location_params
      params.require(:location).permit(:latitude, :longitude)
    end

    def place_params
      params.require(:place).permit(:id)
    end

    def serialized_event
      EventSerializer.new(@event,
                          { include: %i[organizer midpoint_location attendees] }).serializable_hash
    end
  end
end
