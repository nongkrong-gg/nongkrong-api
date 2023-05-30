class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can :manage, Event, organizer_id: user.id
    can %i[check_in read], Event

    return unless user.admin?

    can :manage, :all
  end
end
