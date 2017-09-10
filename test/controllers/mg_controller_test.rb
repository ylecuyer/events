require 'test_helper'

class MgControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test 'should reply to Mailgun bounced webhook' do
    message_id = '20130503182626.18666.16540@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org'

    params = {
      'Message-Id' => "<#{message_id}>",
      'X-Mailgun-Sid' => 'WyIwNzI5MCIsICJhbGljZUBleGFtcGxlLmNvbSIsICI2Il0=',
      'attachment-count' => '1',
      'body-plain' => '',
      'code' => '550',
      'domain' => 'sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org',
      'error' => "5.1.1 The email account that you tried to reach does not exist. Please try\n5.1.1 double-checking the recipient's email address for typos or\n5.1.1 unnecessary spaces. Learn more at\n5.1.1 http://support.example.com/mail/bin/answer.py",
      'event' => 'bounced',
      'message-headers' => '[["Received", "by luna.mailgun.net with SMTP mgrt 8734663311733; Fri, 03 May 2013 18:26:27 +0000"], ["Content-Type", ["multipart/alternative", {"boundary": "eb663d73ae0a4d6c9153cc0aec8b7520"}]], ["Mime-Version", "1.0"], ["Subject", "Test bounces webhook"], ["From", "Bob <bob@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org>"], ["To", "Alice <alice@example.com>"], ["Message-Id", "<20130503182626.18666.16540@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org>"], ["List-Unsubscribe", "<mailto:u+na6tmy3ege4tgnldmyytqojqmfsdembyme3tmy3cha4wcndbgaydqyrgoi6wszdpovrhi5dinfzw63tfmv4gs43uomstimdhnvqws3bomnxw2jtuhusteqjgmq6tm@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org>"], ["X-Mailgun-Sid", "WyIwNzI5MCIsICJhbGljZUBleGFtcGxlLmNvbSIsICI2Il0="], ["X-Mailgun-Variables", "{\\"my_var_1\\": \\"Mailgun Variable #1\\", \\"my-var-2\\": \\"awesome\\"}"], ["Date", "Fri, 03 May 2013 18:26:27 +0000"], ["Sender", "bob@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org"]]',
      'my-var-2' => 'awesome',
      'my_var_1' => 'Mailgun Variable #1',
      'recipient' => 'alice@example.com',
      'signature' => '5f160fea5b003afef4bbbc7fb674f21062e3261ad4a46921858fed7df340c2e1',
      'timestamp' => '1500610467',
      'token' => '0c60bcdc9f788df689f0bf5eb6f8b4cf59c327d4ad567cdab9'
    }

    Timecop.freeze do
      assert_enqueued_with(job: UpdateStatusJob, args: [message_id], at: 30.seconds.from_now) do
        post '/mg/bounced', params: params
      end
    end
  end

  test 'should reply to Mailgun dropped webhook' do
    message_id = '20130503182626.18666.16540@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org'

    params = {
      'Message-Id' => "<#{message_id}>",
      'X-Mailgun-Sid' => 'WyIwNzI5MCIsICJpZG91YnR0aGlzb25lZXhpc3RzQGdtYWlsLmNvbSIsICI2Il0=',
      'attachment-count' => '1',
      'body-plain' => '',
      'code' => '605',
      'description' => 'Not delivering to previously bounced address',
      'domain' => 'sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org',
      'event' => 'dropped',
      'message-headers' => '[["Received", "by luna.mailgun.net with SMTP mgrt 8755546751405; Fri, 03 May 2013 19:26:59 +0000"], ["Content-Type", ["multipart/alternative", {"boundary": "23041bcdfae54aafb801a8da0283af85"}]], ["Mime-Version", "1.0"], ["Subject", "Test drop webhook"], ["From", "Bob <bob@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org>"], ["To", "Alice <alice@example.com>"], ["Message-Id", "<20130503192659.13651.20287@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org>"], ["List-Unsubscribe", "<mailto:u+na6tmy3ege4tgnldmyytqojqmfsdembyme3tmy3cha4wcndbgaydqyrgoi6wszdpovrhi5dinfzw63tfmv4gs43uomstimdhnvqws3bomnxw2jtuhusteqjgmq6tm@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org>"], ["X-Mailgun-Sid", "WyIwNzI5MCIsICJpZG91YnR0aGlzb25lZXhpc3RzQGdtYWlsLmNvbSIsICI2Il0="], ["X-Mailgun-Variables", "{\\"my_var_1\\": \\"Mailgun Variable #1\\", \\"my-var-2\\": \\"awesome\\"}"], ["Date", "Fri, 03 May 2013 19:26:59 +0000"], ["Sender", "bob@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org"]]',
      'my-var-2' => 'awesome',
      'my_var_1' => 'Mailgun Variable #1',
      'reason' => 'hardfail',
      'recipient' => 'alice@example.com',
      'signature' => '85d8410f28abb95ba4eba4e5873ae99408ad6ad7a1108542488bbdb005d86be5',
      'timestamp' => '1500610229',
      'token' => '5318f152d1118fcdd45d0cb642ed3418fa708227b5c8f70040',
      'attachment-1' => nil
    }

    Timecop.freeze do
      assert_enqueued_with(job: UpdateStatusJob, args: [message_id], at: 30.seconds.from_now) do
        post '/mg/dropped', params: params
      end
    end
  end

  test 'should reply to Mailgun delivered webhook' do
    message_id = '20130503182626.18666.16540@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org'

    params = {
      'domain' => 'sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org',
      'my_var_1' => 'Mailgun Variable #1',
      'my-var-2' => 'awesome',
      'message-headers' => '[["Received", "by luna.mailgun.net with SMTP mgrt 8734663311733; Fri, 03 May 2013 18:26:27 +0000"], ["Content-Type", ["multipart/alternative", {"boundary": "eb663d73ae0a4d6c9153cc0aec8b7520"}]], ["Mime-Version", "1.0"], ["Subject", "Test deliver webhook"], ["From", "Bob <bob@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org>"], ["To", "Alice <alice@example.com>"], ["Message-Id", "<20130503182626.18666.16540@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org>"], ["X-Mailgun-Variables", "{\\"my_var_1\\": \\"Mailgun Variable #1\\", \\"my-var-2\\": \\"awesome\\"}"], ["Date", "Fri, 03 May 2013 18:26:27 +0000"], ["Sender", "bob@sandboxd12ec1188b4f479193be5b5052cbc625.mailgun.org"]]',
      'Message-Id' => "<#{message_id}>",
      'recipient' => 'alice@example.com',
      'event' => 'delivered',
      'timestamp' => '1500609914',
      'token' => 'd7d150df5051a0fd5b35f5b58545afd27926c72e6f99811472',
      'signature' => '8d955b9dc75b3b663a2a9684bc4ea431c37f3b06039507b658da77c2f91cabfc',
      'body-plain' => ''
    }

    Timecop.freeze do
      assert_enqueued_with(job: UpdateStatusJob, args: [message_id], at: 30.seconds.from_now) do
        post '/mg/delivered', params: params
      end
    end
  end
end
