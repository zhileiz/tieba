class Post < ApplicationRecord
  acts_as_votable
  belongs_to :user
  has_many :replies, dependent: :destroy
  paginates_per 6
end
