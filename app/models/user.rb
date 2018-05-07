class User < ApplicationRecord
  has_many :action_items
  has_many :memberships
  has_many :teams, :through => :memberships
  #belongs_to :team
   
end
