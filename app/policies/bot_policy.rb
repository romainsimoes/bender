class BotPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def index?
    record.user == user || user.admin?
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

  def webhook_verification?
    true
  end

  def webhook?
    true
  end

  def toggle?
    record.user == user
  end

  def rails_admin?(action)
    case action
      when :destroy, :new
        false
      else
        super
    end
  end

  def add_agenda_entry?
    record.user == user || user.admin?
  end

  def delete_agenda_entry?
    record.user == user || user.admin?
  end

end
