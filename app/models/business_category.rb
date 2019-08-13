class BusinessCategory < ApplicationRecord
  has_many :business_category_tags

  validates :name, presence: true
end
