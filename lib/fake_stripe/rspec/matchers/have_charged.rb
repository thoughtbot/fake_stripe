RSpec::Matchers.define :have_charged do |amount|
  @card_token = :ignore_card_token

  chain :to_card do |card_token|
    @card_token = card_token

    if invalid_card_token?(@card_token)
      raise FakeStripe::InvalidCardToken
    end
  end

  match do |fake_stripe|
    matching_charges(fake_stripe, amount, @card_token).any?
  end

  def matching_charges(fake_stripe, amount, card_token)
    matching_amounts = fake_stripe.charge_calls
      .select(&matches_amount(amount))

    if card_token
      matching_amounts.select(&matches_card_token(card_token))
    else
      matching_amounts
    end
  end

  def matches_amount(amount)
    proc do |charge|
      charge[:amount] == amount
    end
  end

  def matches_card_token(card_token)
    proc do |charge|
      card_token == :ignore_card_token || charge[:card][:id] == card_token
    end
  end

  def invalid_card_token?(card_token)
    card_token.nil? || card_token == ''
  end
end
