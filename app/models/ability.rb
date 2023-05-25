class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can :manage, Event, organizer_id: user.id
    can :check_in, Event do |event|
      event.attendees.where(attendee_id: user.id).empty?
    end
    can :read, Event
  end
end
