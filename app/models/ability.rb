class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can :manage, Event, organizer_id: user.id
    can :read, Event do |event|
      event.attendees.exists?(attendee_id: user.id)
    end
  end
end
