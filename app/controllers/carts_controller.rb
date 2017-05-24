class CartsController < ApplicationController
	def add
		init_cart
		@cart.add_item(params[:id])
		session[:cart9487] = @cart.to_hash
		redirect_to products_path, notice: "已放進購物車"
	end
	def destroy
		session[:cart9487] = nil
		redirect_to cart_path, notice: "購物車已清空"
	end
	def checkout
		@order = Order.new
		@token = Braintree::ClientToken.generate
	end
end
