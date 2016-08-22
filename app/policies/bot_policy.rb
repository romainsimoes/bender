class BotPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user) # User can show his restauran
    end
  end

  def create?
    true # All user can create
  end
end
