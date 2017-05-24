require 'rails_helper'


RSpec.describe Cart, type: :model do

	let (:cart) { Cart.new}
	describe "basic" do

		it "可以把商品丟到到購物車裡，然後購物車裡就有東西了。" do
			cart.add_item 1
			expect(cart.empty?).to be false
		end

		it "如果加了相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變。" do 
			3.times { cart.add_item 1 }
			5.times { cart.add_item 2 }

			expect(cart.items.length).to be 2
			expect(cart.items.first.quantity).to be 3
			expect(cart.items.last.quantity).to be 5
		end

		it "商品可以放到購物車裡，也可以再拿出來。" do
			p1 = FactoryGirl.create(:product)
			p2 = FactoryGirl.create(:product)

			3.times { cart.add_item(p1.id) }
			5.times { cart.add_item(p2.id) }

			expect(cart.items.first.product).to be_kind_of Product
			expect(cart.items.last.product_id).to be p2.id

		end
		
		it "可以計算整台購物車的總消費金額。" do
			p1 = FactoryGirl.create(:product, :price_100)
			p2 = FactoryGirl.create(:product, :price_250)

			3.times { cart.add_item(p1.id) }
			4.times { cart.add_item(p2.id) }

			expect(cart.total_price).to be 1300
		end

		it "特別活動 滿額滿千折百。" do
			p1 = Product.create(title: "P1", price: 100)
			p2 = Product.create(title: "P2", price: 250)

			3.times { cart.add_item(p1.id) }
			4.times { cart.add_item(p2.id) }

			t = Time.local(2017, 1, 1, 12, 0, 0)
			Timecop.travel(t)

			if Time.now.month == 1
				expect(cart.total_price).to be (1300 - 100)
			else
				expect(cart.total_price).to be 1300
			end
		end

		it "X'mas 打九折" do
			p1 = Product.create(title: "P1", price: 100)
			p2 = Product.create(title: "P2", price: 250)

			3.times { cart.add_item(p1.id) }
			4.times { cart.add_item(p2.id) }

			t = Time.local(2017, 12, 26, 12, 0, 0)
			Timecop.travel(t)

			if Time.now.month == 12 and Time.now.day == 25
				expect(cart.total_price).to be (1300 * 0.9)
			else
				expect(cart.total_price).to be 1300
			end
		end

	end

	describe "advence" do
		it "可以將購物車內容轉換成 Hash 並存到 Session 裡。" do
			3.times { cart.add_item 1 }
			2.times { cart.add_item 2 }

			expect(cart.to_hash).to eq cart_hash
		end

		it "也可以存放在 Session 的內容（Hash 格式），還原成購物車的內容。" do
			cart = Cart.from_hash(cart_hash)

			expect(cart.items.length).to be 2
			expect(cart.items.first.product_id).to be 1
			expect(cart.items.last.quantity).to be 2
		end

		private

		def cart_hash
			{
				"items" => [
					{"product_id" => 1, "quantity" => 3},
					{"product_id" => 2, "quantity" => 2}
				]
			}
			
		end
	end

end
