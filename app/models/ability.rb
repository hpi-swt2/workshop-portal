class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    user ||= User.new # guest user (not logged in)

    if user.role? :pupil
      # Pupils can only edit their own profiles
      can [:new, :create], Profile
      can [:index, :show, :edit, :update, :destroy], Profile, user: { id: user.id }
      # Pupils can only edit their own applications
      can [:new, :create], ApplicationLetter
      can [:index, :show, :edit, :update, :destroy], ApplicationLetter, user: { id: user.id }
    end
    if user.role? :coach
      # Coaches can view Applications for Event
      can [:view_applicants], Event
      can [:view_and_add_notes, :show], ApplicationLetter
    end
    if user.role? :organizer
      can [:index, :show], Profile
      can [:index, :show, :view_and_add_notes], ApplicationLetter
      # Organizers can view and edit Applications for Events
      can [:view_applicants, :edit_applicants], Event
    end
    if user.role? :admin
      can :manage, :all
    end
  end
end
