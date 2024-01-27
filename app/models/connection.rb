class Connection < ApplicationRecord
  belongs_to :user

  belongs_to :requested, foreign_key: :connected_user_id, class_name: 'User'
  belongs_to :received, foreign_key: :user_id, class_name: 'User'

  validates :connected_user_id, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending accepted rejected deleted] }
end
