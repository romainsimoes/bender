class BotPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all?
      else
        scope.where(user: user)
      end
    end
  end

  def index?
    true
  end

  def create?
    true
  end

  def destroy?
    record.user == user || user.admin?
  end

  def update?
    record.user == user || user.admin?
  end

  def webhook_validation?
    true
  end

  def webhook?
    true
  end
end
