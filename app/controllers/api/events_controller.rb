module Api
  class EventsController < ApiController
    load_and_authorize_resource

    def show
      render json: EventSerializer.new(@event, { include: %i[organizer final_location attendees] }).serializable_hash
    end
  end
end
