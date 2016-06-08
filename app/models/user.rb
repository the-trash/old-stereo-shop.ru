# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  birthday               :date
#  phone                  :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  middle_name            :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  reviews_count          :integer          default(0)
#  full_name              :string(255)
#  city_id                :integer          default(0)
#  address                :string(255)
#  index                  :integer
#  subscription_settings  :hstore
#
# Indexes
#
#  index_users_on_city_id               (city_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'stereoshop@ru'
  TEMP_EMAIL_REGEX = /\Astereoshop@ru/

  before_save :set_full_name, unless: :full_name?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable,
         :async

  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update

  has_many :votes,
    dependent: :destroy,
    class_name: 'Rating',
    foreign_key: :user_id,
    inverse_of: :user

  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :wishes, dependent: :destroy do
    def product_exists?(product_id)
      exists?(product_id: product_id)
    end

    def products
      Product.where(id: pluck(:product_id))
    end
  end

  %i(cart subscribed_email).each do |r|
    has_one r, dependent: :destroy
  end

  belongs_to :city

  hstore_accessor :subscription_settings,
    unsubscribe: :boolean,
    news: :boolean,
    bonus: :boolean,
    product_delivered: :boolean,
    deals: :boolean

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          full_name: auth.extra.raw_info.name,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    email && email !~ TEMP_EMAIL_REGEX
  end

  private

  def set_full_name
    self.full_name =
      [first_name, middle_name, last_name].compact.map(&:strip).join(' ')
  end
end
