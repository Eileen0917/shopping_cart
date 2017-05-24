require 'rails_helper'

RSpec.describe CartItem, type: :model do

	describe "basic" do
		it "每個 Cart Item 都可以計算它自己的金額（小計）。" do
			p1 = Product.create(title: "P1", price: 100)
			p2 = Product.create(title: "P2", price: 250)

			cart = Cart.new
			3.times { cart.add_item(p1.id) }
			4.times { cart.add_item(p2.id) }

			expect(cart.items.first.total_price).to be 300
			expect(cart.items.last.total_price).to be 1000
		end
	end
end
