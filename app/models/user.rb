class User < ApplicationRecord
  has_many :action_items
  #belongs_to :team
end
