class MailgunService
  def initialize
    @mg_client = Mailgun::Client.new ENV['MAILGUN_API_KEY']
  end

  def total_sent_mail_this_month
    get_domains.map { |domain| domain_accepted_total_this_month(domain['name']) }.reduce(:+)
  end

  private

  def get_domains
    result = @mg_client.get 'domains', { limit: 5, skip: 0 }
    result.to_h['items']
  end

  def domain_accepted_total_this_month(domain_name)
    result = @mg_client.get "#{domain_name}/stats/total", event: 'accepted', duration: '30d'
    result.to_h['stats'].map { |stat| stat['accepted']['total'] }.reduce(:+)
  end
end
