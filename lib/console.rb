# frozen_string_literal: true

class Console
  ACTIONS = {
    '1' => proc { |instance| instance.show_products },
    '2' => proc { |instance| instance.select_product },
    '3' => proc { |instance| instance.add_coin },
    '4' => proc { |instance| instance.show_balance },
    '5' => proc { raise SystemExit }
  }.freeze

  def initialize
    @products, @coins = DataLoader.load
    @vending_machine = VendingMachine.new(coins: @coins, products: @products)
  end

  def start
    show_products
    select_action
  end

  def select_action
    puts I18n.t('select_action')
    puts I18n.t('actions')

    action = ACTIONS[gets.chomp] || ACTIONS['1']
    system('clear')
    action.call(self)
    select_action
  end

  def show_products
    puts Helpers::TableCreator.call(products)
  end

  def select_product
    show_products
    puts I18n.t('select_product')

    result = vending_machine.select_product(gets.chomp)
    message =
      result.success ? I18n.t('product', name: result.product.name) : I18n.t(result.error_key)
    puts message
    return_change(result.change)
  end

  def add_coin
    puts I18n.t('available_coins', values: Coin::AVAILABLE_VALUES.join(', '))
    puts I18n.t('type_coin_value')

    result = vending_machine.add_coin(gets.chomp)
    if result.success
      show_balance
    else
      puts I18n.t(result.error_key)
    end
  end

  def show_balance
    puts I18n.t('balance', value: vending_machine.user_balance)
  end

  def return_change(change)
    return if change.nil? || change.empty?

    puts I18n.t('change')
    puts Helpers::TableCreator.call(change, with_numbers: false)
  end

  private

  attr_reader :products, :vending_machine
end
