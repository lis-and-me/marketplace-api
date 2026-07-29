class AiPolicy < ApplicationPolicy
  def chat?
    admin?
  end
end