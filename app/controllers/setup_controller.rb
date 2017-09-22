class SetupController < ApplicationController
  include Wicked::Wizard

  steps :create_admin

  def show
    render_wizard
  end
end
