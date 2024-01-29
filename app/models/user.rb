class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :work_experiences, dependent: :destroy # chidren has plural name

  has_many :connections, dependent: :destroy
  
  PROFILE_TITLE = [
    'Senior Ruby on Rails Developer',
    'Full Stack Ruby on Rails Developer',
    'Senior Full Stack Ruby on Rails Developer',
    'Junior Full Stack Ruby on Rails Developer',
    'Senior Java Developer',
    'Senior Frontend Developer',
  ].freeze

  def name 
    "#{first_name} #{last_name}".strip
  end

  def address 
    "#{city}, #{state}, #{country} #{street_address}, #{pincode}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["city", "country"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def check_if_already_connected?(user)
    self != user && !my_connections(user).present?
  end

  def my_connections(user)
    Connection.where("(user_id = ? AND connected_user_id = ?) OR (user_id = ? AND connected_user_id = ?)", user.id, id, id, user.id)
  end

  def mutually_connected_ids(user)
    self.connected_user_ids.intersection(user.connected_user_ids)
  end
end
