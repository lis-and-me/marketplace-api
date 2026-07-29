class DashboardPolicy < ApplicationPolicy
  def show?
    admin?
  end

  private

  def admin?
    user.present? && user.admin?
  end
end 