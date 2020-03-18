class BillingController < ApplicationController
  before_action :authorize

  def index
    @user = current_user
  end

  def new_card
  end

  def create_card
    respond_to do |format|
      if current_user.card_token.nil?
        customer = Stripe::Customer.create({email: current_user.email, card: params[:stripeToken]})
        Stripe::Charge.create({
          customer: customer.id,
          amount: 10000,
          description: 'Payment crawler',
          currency: 'usd'
        })
        current_user.update(card_token: customer.id)
        BillingJob.set(wait: 4.seconds).perform_later(current_user)
      end
      card_token = params[:stripeToken]
      if card_token.nil?
        format.html { redirect_to billing_index_path, error: "Oops"}
      end
      customer = Stripe::Customer.new current_user.card_token
      customer.source = card_token
      customer.save
      format.html { redirect_to success_path }
    end
  end

  def success
  end
end
