class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if admin?
        scope.all
      else
        scope.where(user: user)
      end
    end

    private

    def admin?
      user.admin?
    end
  end

  def index?
    true
  end

  def show?
    admin? || owner?
  end

  def update?
    admin?
  end

  def destroy?
    false
  end

  private

  def admin?
    user.admin?
  end

  def owner?
    record.user == user
  end
end