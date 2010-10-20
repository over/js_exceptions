class JsExceptionsController < ApplicationController
  def deliver
    HoptoadNotifier.notify(
          :error_class   => "JS Error",
          :error_message => "JS Error: #{params[:subject]}",
          :parameters    => params
        )
    
    render :text => "OK"
  end
end