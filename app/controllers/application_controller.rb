class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :check_at_least_one_user!
  before_action :authenticate_user!
  before_action :set_upcomming_events

  include Pundit
  after_action :verify_authorized, unless: -> { devise_controller? || ckeditor_controller? || mg_controller? || setup_controller? }

  private

  def check_at_least_one_user!
    redirect_to '/wizard' unless User.count > 0
  end

  def set_upcomming_events
    @upcommig_events = Event.order('start asc').where('start >= ?', Time.now).limit(3)
  end

  def ckeditor_controller?
    is_a?(Ckeditor::ApplicationController)
  end

  def mg_controller?
    is_a?(MgController)
  end

  def setup_controller?
    is_a?(SetupController)
  end
end
