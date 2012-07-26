require 'securerandom'
require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessor   :password, :password_confirmtion
  attr_accessible :login, :password, :password_confirmation

  validates_presence_of     :login
  validates_uniqueness_of   :login
  validates_length_of       :login, :in => 5..64
  
  validates_presence_of     :password_hash, if: :persisted?

  validates_length_of       :password, :in => 7..64, :allow_blank => true
  validates_presence_of     :password, if: :new_record?
  validates_confirmation_of :password, if: :new_record?

  before_create :encrypt_password

  def crypted_password
    @crypted_password ||= BCrypt::Password.new(password_hash)
  end

  def valid_auth_token? test_token
    auth_token == test_token
  end

  def delete_auth_token!
    update_attribute :auth_token, nil
  end

  def generate_auth_token
    self.auth_token = SecureRandom.hex
  end

  def generate_auth_token!
    (token = generate_auth_token) && save
    token
  end

  protected

  def encrypt_password
    self.password_hash = BCrypt::Password.create(password)
  end
end
