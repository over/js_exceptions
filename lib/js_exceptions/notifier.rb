module JsExceptions
  class Notifier < ActionMailer::Base
    @@sender_address = %("JS Exception Notifier" <jsexception.notifier@default.com>)
    cattr_accessor :sender_address
  
    @@exception_recipients = []
    cattr_accessor :exception_recipients
  
    @@email_prefix = "[ERROR] "
    cattr_accessor :email_prefix
  
    def self.reloadable?() false end
  
    def exception_notification(request, exception, data = {})
      @request = request
      @backtrace = sanitize_backtrace(exception["content"])
      @remote_ip = request.ip
      @exception = exception
      
      mail(:to => exception_recipients, :from => sender_address, :subject => subject) do |format|
        format.text { render "#{File.dirname(__FILE__)}/views/exception_notification_text" }
      end
    end
  
    private
  
      def sanitize_backtrace(trace)
        re = Regexp.new(/^#{Regexp.escape(rails_root)}/)
        trace.map { |line| Pathname.new(line.gsub(re, "[RAILS_ROOT]")).cleanpath.to_s }
      end
  
      def rails_root
        @rails_root ||= Pathname.new(Rails.root).cleanpath.to_s
      end

  end
end
