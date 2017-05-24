FactoryGirl.define do
  factory :order_item do
    product nil
    order nil
    price 1
    quantity 1
  end
end
