class Team < ApplicationRecord
  	has_many :memberships
	has_many :action_items
	has_many :users, :through => :memberships
end
