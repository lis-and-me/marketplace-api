class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin? && !self_record?
  end

  private

  def self_record?
    user.id == record.id
  end
end