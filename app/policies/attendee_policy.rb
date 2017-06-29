class AttendeePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

  def logs?
    show?
  end

  def ticket?
    show?
  end

  def check_invitation_status?
    update?
  end

  def send_invitation?
    update?
  end
end
