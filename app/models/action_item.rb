class ActionItem < ApplicationRecord
  belongs_to :user
  belongs_to :team
  serialize :multi_wrong, Hash
end
