module Api
  class EventsController < ApiController
    load_and_authorize_resource

    def show
      render json: serialized_event
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

      @event.check_in!(attendee: current_user, **check_in_params.to_h.symbolize_keys)

      render json: serialized_event, status: :created
    end

    protected

    def event_params
      params.require(:event).permit(:title, :description, :date)
    end

    def check_in_params
      params.require(:location).permit(:latitude, :longitude)
    end

    def serialized_event
      EventSerializer.new(@event, { include: %i[organizer final_location attendees] }).serializable_hash
    end
  end
end
