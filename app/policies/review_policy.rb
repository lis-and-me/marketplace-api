class ReviewPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
  scope.all
end

    private

    def admin?
      user.present? && user.admin?
    end
  end

  def index?
    true
  end

  def show?
    admin? || owner? || record.approved?
  end

  def create?
    user.present?
  end

  def update?
    owner? && !record.approved?
  end

  def approve?
    admin?
  end

  def reject?
    admin?
  end

  def destroy?
    admin? || owner?
  end

  private

  def owner?
    user.present? && record.user == user
  end
end