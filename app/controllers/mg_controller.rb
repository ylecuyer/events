class MgController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:webhook]
  skip_before_action :authenticate_user!, only: [:webhook]

  def webhook
    UpdateStatusJob.set(wait: 30.seconds).perform_later(params[:'Message-Id'][1..-2])
  end

end
