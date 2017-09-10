class MailtesterService
  def initialize(params)
    @event = params[:event]
  end

  def result
    response = Faraday.get url
    JSON.parse(response.body)
  end

  private

  def url
    "https://www.mail-tester.com/#{ENV['MAILTESTER_LOGIN']}-Event#{@event.id}&format=json"
  end
end
