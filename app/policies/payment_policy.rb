class PaymentPolicy < ApplicationPolicy
  def show?
    admin? || owner?
  end

  def create?
    user.present?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  class Scope < Scope
    def resolve
      return scope.all if user&.admin?

      scope.joins(:order).where(orders: { user_id: user.id })
    end
  end

  private

  def admin?
    user&.admin?
  end

  def owner?
    record.order.user_id == user.id
  end
end