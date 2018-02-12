class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  has_many :friendships
  has_many :friends, through: :friendships

  def full_name
    return "#{first_name} #{last_name}" if (first_name || last_name)
    "Anonymous"
  end

  def stock_already_added?(ticker_symbol)
    # first find the stock in the stocks table
    stock = Stock.find_by_ticker(ticker_symbol)

    # return false if the stock is not present
    return false unless stock

    # check if the stock is already tracked by the user
    user_stocks.where(stock_id: stock.id).exists?
  end

  def under_stock_limit?
    # check if the user is under their stock limit of 10
    user_stocks.count < 10
  end

  def can_add_stock?(ticker_symbol)
    # if the user's stock limit is less than 10
    # and the stock is not already added
    under_stock_limit? && !stock_already_added?(ticker_symbol)
  end

  def self.search(param)
    param.strip!
    param.downcase!
    to_send_to = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
    return nil unless to_send_to
    to_send_to
  end

  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end
end
