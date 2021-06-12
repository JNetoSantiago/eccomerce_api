# frozen_string_literal: true

# send mail when order is created
class OrderMailer < ApplicationMailer
  default from: 'no-reply@marketplace.com'
  def send_confirmation(order)
    @order = order
    @user = @order.user
    mail to: @user.email, subject: 'Order Confirmation'
  end
end
