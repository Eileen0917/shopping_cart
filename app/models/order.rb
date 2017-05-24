class Order < ApplicationRecord
  has_many :order_items

  include AASM

  aasm column: "state" do
    state :pending, initial: true
    state :cancelled, :paid, :shipped, :delivered, :rejected, :refunded

    event :pay do
      transitions from: :pending, to: :paid

      after_transaction do
        puts "send SMS to #{tel}"
      end
    end

    event :ship do
      transitions from: :paid, to: :shipped
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end

    event :reject do
      transitions from: :delivered, to: :rejected
    end

    event :refund do
      transitions from: [:rejected, :paid], to: :refunded
    end

    event :cancel do
      transitions from: [:pending, :refunded], to: :cancelled
    end
  end
end