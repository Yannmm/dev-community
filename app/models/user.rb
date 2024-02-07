class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable, authentication_keys: [:login]

  has_many :work_experiences, dependent: :destroy # chidren has plural name

  has_many :connections, dependent: :destroy

  validates *%i[first_name last_name profile_title email], presence: true

  validates :username, presence: true, uniqueness: true
  
  PROFILE_TITLE = [
    'Senior Ruby on Rails Developer',
    'Full Stack Ruby on Rails Developer',
    'Senior Full Stack Ruby on Rails Developer',
    'Junior Full Stack Ruby on Rails Developer',
    'Senior Java Developer',
    'Senior Frontend Developer',
  ].freeze

  attr_writer :login

  def login 
    @login || username || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if(login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value  => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def name 
    "#{first_name} #{last_name}".strip
  end

  def address
    return nil if city.blank? && state.blank? && country.blank? && pincode.blank?

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
