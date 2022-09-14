class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :display_name, presence: true
  validates :user_name, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/, message: "は半角英数字で入力してください。" }
  validates :email, presence: true, uniqueness: true

end
