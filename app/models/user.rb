class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects
  has_many :project_members
  has_many :child_tasks

  validates :display_name, presence: true
  validates :user_name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

end
