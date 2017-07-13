class EventPolicy < ApplicationPolicy
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

  def print_list?
    show?
  end

  def send_invitations?
    update?
  end

  def check_invitations_status?
    update?
  end

  def import_csv?
    update?
  end

  def do_import_csv?
    update?
  end

  def export_csv?
    show?
  end

  def export_failed?
    show?
  end

  def send_test_mail?
    update?
  end

  def mailtester?
    show?
  end

  def do_mailtester?
    update?
  end

  def checkin?
    show?
  end

  def ticket?
    show?
  end

  def validate?
    update?
  end
  
  def live?
    show?
  end
end
