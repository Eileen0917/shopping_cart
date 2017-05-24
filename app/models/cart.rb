class Cart

	attr_reader :items

	def initialize(items = [])
		@items = items
	end	

	def add_item(n)
		found_item = items.find { |item| item.product_id == n }

		if found_item
			found_item.increment
		else
			items << CartItem.new(n)
		end
 
	end

	def empty?
		@items.empty?
	end

	def total_price
		total = items.reduce(0) { |total, item| total + item.total_price}

		if Time.now.month == 1 && total >= 1000
			total -= 100
		elsif Time.now.month == 12 and Time.now.day == 25
			total *= 0.9
		else
			total
		end
	end

	def to_hash
		all_items = items.map {|item| {"product_id" => item.product_id, "quantity" => item.quantity}}
		
		{
			"items" => all_items
		}
	end

	def self.from_hash(hash)
		if hash.nil? or !hash.has_key?("items")
			new
		else
			new hash["items"].map {|item| CartItem.new(item["product_id"], item["quantity"])}
		end


	end

end