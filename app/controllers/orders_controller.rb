class OrdersController < ApplicationController
	def create
		@order = Order.new(order_params)
		@cart.items.each do |item|
			@order.order_items.build(product: item.product, price: item.product.price, quantity: item.quantity)
		end

		if @order.save
			#付錢
			nonce = params[:payment_method_nonce]

			result = Braintree::Transaction.sale(
			  :amount => @cart.total_price,
			  :payment_method_nonce => nonce,
			  :options => {
			    :submit_for_settlement => true
			  }
			)
			
			
			if result.success? || result.transaction
				#清空購物車
				session[:cart9487] = nil
				#寄信通知
				OrderMailer.order_confirm(@order).deliver_now
				#走回product_path
				redirect_to products_path , notice: "感謝大爺！"
			else
				flash[:notice] = "刷卡發生錯誤"
				render "carts/checkout"
			end

		else
			render "carts/checkout"
			# redirect_to cart_path, notice: "訂單發生錯誤"
		end
	end

	private
	def order_params
		params.require(:order).permit(:recipient, :tel, :email)
	end
end
