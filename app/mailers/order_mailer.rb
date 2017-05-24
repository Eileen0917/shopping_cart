class OrderMailer < ApplicationMailer

  def order_confirm(order)
    @total_price = order.order_items.reduce(0) { |sum, item| sum + item.price }
    mail to: order.email, subject: "訂單確認"
  end
end