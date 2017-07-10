class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_upcomming_events
  before_action :authenticate_user!

  include Pundit
  after_action :verify_authorized, unless: lambda { devise_controller? || ckeditor_controller? || mg_controller?}

  private

  def set_upcomming_events
    @upcommig_events = Event.order('start asc').where('start >= ?', Time.now).limit(3)
  end

  def ckeditor_controller?
    is_a?(Ckeditor::ApplicationController) 
  end

  def mg_controller?
    is_a?(MgController)
  end

end
