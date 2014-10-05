class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :votes,
    dependent: :destroy,
    class_name: 'Rating',
    foreign_key: :user_id,
    inverse_of: :user

  has_many :reviews, dependent: :destroy
end
