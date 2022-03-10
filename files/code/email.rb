require 'net/smtp'
require_relative 'constants'
require 'erb'
require 'time'


class Email 
  include ConfigAlerts
  include ConstantsErrors
  include ConstantsGeneral

    def build_email(all_results)
      f = File.open(PATH_HTML, "r")
      template_html = ERB.new(f.read)
      html_email = template_html.result(binding)

      message = <<~MESSAGE_END
      From: #{@@email_config["from"]} 
      To: #{@@email_config["to"]}
      MIME-Version: 1.0
      Content-type: text/html
      Subject: #{@@email_config["subject"]}
  
      #{html_email}
      
      MESSAGE_END
      return message

    end
  
    def send_email(email_to, message)
      begin
        Net::SMTP.start(@@email_config["server"], @@email_config["port"]) do |smtp|
          smtp.send_message message, @@email_config["from"], email_to end
      rescue Exception => e
          @@log_sys.error(SMTP_ERROR + e.message) #+ "Backtrace: " + e.backtrace.join(" / "))
          raise Exception,  SMTP_ERROR + e.message
        end
    end
  
  end 