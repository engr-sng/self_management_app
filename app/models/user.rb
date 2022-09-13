class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects
  has_many :project_members
  has_many :child_tasks

  has_one_attached :profile_image

  validates :display_name, presence: true
  validates :user_name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def task_count
    self.child_tasks.count
  end

  def task_complete
    self.child_tasks.where(progress: 100).count
  end

  def task_remaining
    task_count - task_complete
  end

  def task_progress
    sum_progress = self.child_tasks.sum(:progress)
    count_tasks = self.child_tasks.count
    if count_tasks == 0
      0
    elsif sum_progress == 0
      0
    else
      (sum_progress/count_tasks).floor
    end
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_fill: [width, height]).processed
  end

  def self.guest
    find_or_create_by!(user_name: 'guestuser') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.display_name = "ゲストユーザー"
      user.email = "guest@example.com"
    end
  end

end
