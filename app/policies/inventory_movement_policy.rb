class InventoryMovementPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin?
  end

  def create?
    admin?
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      admin? ? scope.all : scope.none
    end

    private

    def admin?
      user.present? && user.admin?
    end
  end
end