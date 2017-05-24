class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :init_cart

  private
  
  def init_cart
  	@cart = Cart.from_hash(session[:cart9487])
  end
end
